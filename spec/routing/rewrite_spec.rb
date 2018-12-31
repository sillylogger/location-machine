require "rails_helper"
require 'rack/rewrite/yaml_rule_set'

describe "rack-rewrite" do

  let(:rules_file) { Rails.root.join('config', 'rewrite.yml') }

  before do
    @app = Class.new { def call(app); true; end }.new
    @rack = Rack::Rewrite.new(@app,
                              :klass => Rack::Rewrite::YamlRuleSet,
                              :options => { :file_name => rules_file })
  end

  def request path, options = {}
    {
      "SERVER_PROTOCOL" => "HTTP/1.1",
      "REQUEST_METHOD" => "GET",
      "REQUEST_PATH" => path,
      "REQUEST_URI" => path,
      "HTTP_VERSION" => "HTTP/1.1",
      "HTTP_HOST" => "www.locationmachine.io",
      "HTTP_CONNECTION" => "keep-alive",
      "HTTP_UPGRADE_INSECURE_REQUESTS" => "1",
      "HTTP_USER_AGENT" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36",
      "HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
      "HTTP_ACCEPT_ENCODING" => "gzip, deflate, sdch",
      "HTTP_ACCEPT_LANGUAGE" => "en-US,en;q=0.8,id;q=0.6,nl;q=0.4",
      "SERVER_NAME" => "www.locationmachine.io",
      "SERVER_PORT" => "",
      "PATH_INFO" => path,
      "REMOTE_ADDR" => "127.0.0.1",
      "rack.url_scheme" => "https",
      "rack.after_reply" => [],
      "ORIGINAL_FULLPATH" => path,
      "ORIGINAL_SCRIPT_NAME" => ""
    }.merge(options)
  end

  let(:scheme)  { 'https' }
  let(:host)    { 'www.locationmachine.io' }
  let(:port)    { nil }

  def get path
    response = @rack.call request(path, {
      "HTTP_HOST" => "#{host}#{":#{port}" if port}",
      "SERVER_NAME" => host,
      "rack.url_scheme" => scheme
    })

    return response if response == true

    response[1]['Location']
  end

  context "https://www.locationmachine.io" do
    it { expect(get('/')).to eq(true) }
  end

  shared_examples :path_with_utm_source do

    it "redirects naked paths to the proper domain" do
      expect(get('')).to eq(
        'https://www.locationmachine.io')

      expect(get('/')).to eq(
        'https://www.locationmachine.io/')
    end

    it "redirects to the proper domain with path and params" do
      expect(get('/?utm_source=foobar')).to eq(
        'https://www.locationmachine.io/?utm_source=foobar')

      expect(get('/foobar?utm_source=foobar')).to eq(
        'https://www.locationmachine.io/foobar?utm_source=foobar')
    end
  end


  #
  # Incorrect domains redirect directly to
  # the one true domain: https://www.locationmachine.io, unless dev
  #

  context "http://locationmachine.io" do
    let(:scheme)  { 'http' }
    let(:host)    { 'locationmachine.io' }
    it_behaves_like :path_with_utm_source
  end

  context "https://locationmachine.io" do
    let(:scheme)  { 'https' }
    let(:host)    { 'locationmachine.io' }
    it_behaves_like :path_with_utm_source
  end

  context "http://www.locationmachine.io" do
    let(:scheme)  { 'http' }
    let(:host)    { 'www.locationmachine.io' }
    it_behaves_like :path_with_utm_source
  end

  # TODO: accept and redirect to arbitrary port
  # context "http://local.locationmachine.io:3000" do
  #   let(:scheme)  { 'http' }
  #   let(:host)    { 'local.locationmachine.io' }
  #   let(:port)    { 3000 }
  #
  #   it "redirects to https dev url" do
  #     expect(get('/?utm_source=foobar')).to eq(
  #       'https://local.locationmachine.io:3000/?utm_source=foobar')
  #
  #     expect(get('/foobar?utm_source=foobar')).to eq(
  #       'https://local.locationmachine.io:3000/foobar?utm_source=foobar')
  #   end
  # end

  context "https://local.locationmachine.io:3000" do
    let(:scheme)  { 'https' }
    let(:host)    { 'local.locationmachine.io' }
    let(:port)    { 3000 }

    it "does nothing" do
      expect(get('/?utm_source=foobar')).to eq(true)
      expect(get('/foobar?utm_source=foobar')).to eq(true)
    end
  end

end

