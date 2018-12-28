require 'rails_helper'

describe FormatHelper do

  describe "+date" do
    let(:value) { Date.civil(2008, 8, 8) }

    it "formats the date" do
      expect(FormatHelper.date(value)).to eq('August 8, 2008')
    end

    context "when nil" do
      let(:value) { nil }

      it "returns empty string" do
        expect(FormatHelper.date(value)).to eq('')
      end
    end

    context "when given a datetime" do
      let(:value) { Time.parse('Wed, 8 Aug 2008 10:34:42 UTC +00:00') }

      it "still shows just the date" do
        expect(FormatHelper.date(value)).to eq('August 8, 2008')
      end
    end

  end

  describe "+link" do

    let(:url) { "http://www.example.com/cat.jpg" }
    let(:link) { FormatHelper.link url }

    let(:parsed_link) {
      doc = Nokogiri::HTML::fragment link
      doc.css('a').first
    }

    it "returns empty string if given nil" do
      expect(FormatHelper.link(nil)).to be_blank
    end

    it "returns a link with the url as the content" do
      expect(parsed_link[:href]).to eq(url)
    end

    it "doesn't display unnecessary text" do
      expect(parsed_link.text).to eq('example.com/cat.jpg')
    end

    it "default links to a new page" do
      expect(parsed_link[:target]).to eq('_blank')
    end

    it "default links to a new page" do
      expect(parsed_link[:rel]).to eq('nofollow')
    end

    context "when overriding the target option" do
      let(:link) { FormatHelper.link url, target: '_parent' }

      it "default allows you to override the link" do
        expect(parsed_link[:target]).to eq('_parent')
      end
    end

    context "when you want to leave the www" do
      let(:link) { FormatHelper.link url, leave_www: true }

      it "default allows you to override the link" do
        expect(parsed_link.text).to include('www.example.com')
      end
    end

    context "when the url is https" do
      let(:url) { "https://www.example.com/cat.jpg" }

      it "doesn't display unnecessary text" do
        expect(parsed_link.text).to eq('example.com/cat.jpg')
      end
    end
  end

  describe "+mail" do
    let(:address) { "yuda.cogati@kmkonline.co.id" }

    let(:parsed_link) {
      html = FormatHelper.mail address
      doc = Nokogiri::HTML::fragment html
      doc.css('a').first
    }

    it "returns empty string if given nil" do
      expect(FormatHelper.mail(nil)).to be_blank
    end

    it "returns a link with the address as the content" do
      expect(parsed_link[:href]).to eq("mailto:#{address}")
    end

    it "doesn't display unnecessary text" do
      expect(parsed_link.text).to eq('yuda.cogati')
    end
  end

  describe "+tel" do
    let(:number) { "+6287877390515" }

    let(:parsed_link) {
      html = FormatHelper.tel number
      doc = Nokogiri::HTML::fragment html
      doc.css('a').first
    }

    it "returns empty string if given nil" do
      expect(FormatHelper.tel(nil)).to be_blank
    end

    it "returns a link with the address as the content" do
      expect(parsed_link[:href]).to eq("tel:#{number}")
    end
  end

  describe "+host" do
    let(:url) { "http://www.example.com/cat.jpg" }

    let(:host) { FormatHelper.host url }

    it "doesn't display unnecessary text" do
      expect(host).to eq('Example')
    end
  end

  describe "+markdownify" do

    it "handles nil" do
      expect(FormatHelper.markdownify(nil)).to be_present
    end

    it "doesn't mutate the original string" do
      source = "This has a \r that will be replaced"
      FormatHelper.markdownify source
      expect(source).to include("\r")
    end

    it "converts markdown" do
      source = "This *is* awesome"
      html = FormatHelper.markdownify source
      doc = Nokogiri::HTML::fragment html
      expect(doc.css('em').text).to eq('is')
    end

    it "wraps the markdown in a .b-markdown for css" do
      source = "> Tommy was awesome"
      html = FormatHelper.markdownify source
      doc = Nokogiri::HTML::fragment html
      expect(doc.css('.b-markdown').size).to eq 1
    end

    it "respects the option: class" do
      source = "# Rock"
      html = FormatHelper.markdownify source, class: 'b-foobar'
      doc = Nokogiri::HTML::fragment html
      expect(doc.css('.b-foobar.b-markdown').size).to eq 1
    end

    it "returns an html safe string" do
      source = "Iwan __loves__ his hand in his shirt"
      html = FormatHelper.markdownify source
      expect(html).to be_html_safe
    end

    describe "redcarpet::renderer::html" do

      it "removes the source's html" do
        source = "this <script>alert('foo');</script> is bad"
        html = FormatHelper.markdownify source
        expect(html).not_to include('script')
        # this alert('foo'); is bad
      end

      it "replaces newlines returns with br's" do
        source = "This \n has a br"
        expect(FormatHelper.markdownify(source)).to include("<br>")
      end

      it "replaces windows based carriage returns with br's" do
        source = "This \r has a br"
        expect(FormatHelper.markdownify(source)).to include("<br>")
      end

    end

    describe "redcarpet::markdown" do

      it "autolinks" do
        source = "www.example.com is a great website"
        html = FormatHelper.markdownify source
        doc = Nokogiri::HTML::fragment html
        links = doc.css('a')
        expect(links.size).to eq(1)
        expect(links.first[:href]).to include("example.com")

        source = "http://example.com is a great website"
        html = FormatHelper.markdownify source
        doc = Nokogiri::HTML::fragment html
        links = doc.css('a')
        expect(links.size).to eq(1)
        expect(links.first[:href]).to include("example.com")

        source = "example.com is a great website"
        html = FormatHelper.markdownify source
        doc = Nokogiri::HTML::fragment html
        links = doc.css('a')
        expect(links.size).to eq(0)
      end

    end

  end

end
