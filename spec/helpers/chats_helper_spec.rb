require 'rails_helper'

describe ChatsHelper do

  describe "#native_chat_url" do
    let(:urls) {
      {
        'facebook' => 'https://m.me/',
        'whatsapp' => 'https://wa.me/',
        'zalo' => 'https://zalo.me/'
      }
    }
    it "returns correct url" do
      expected = '123'

      urls.each do |k,v|
        expect(helper.native_chat_url(k, expected)).to eq "#{v}#{expected}"
      end
    end

    it "strips any non-number characters" do
      data = [%w(+00123 123), %w(+62123 62123),
              %w(+621-2-3 62123), %w(+62\ 1\ 2\ 3 62123)]
      urls.each do |k, v|
        data.each do |item|
          input, output = item
          expect(helper.native_chat_url(k, input)).to eq "#{v}#{output}"
        end
      end
    end

    context 'whatsapp' do
      it "adds the regarding text if supplied" do
        expect(helper.native_chat_url('whatsapp', '+00123', regarding: 'foo bar')).to include('text=')
        expect(helper.native_chat_url('whatsapp', '+00123', regarding: 'foo bar')).to include('foo%20bar')
      end
    end
  end
end
