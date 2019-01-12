require 'rails_helper'

describe ApplicationController do

  controller do
    def index
      render plain: 'ApplicationController#index'
    end
  end

  describe '#force_canonical_host' do

    let!(:host_setting) { Setting.create name: "site.host", value: "locationmachine.io" }

    it "passes through if using the canonical host" do
      request.host = host_setting.value

      get :index, params: {}

      expect(response).to be_successful
      expect(response.body).to include('ApplicationController#index')
    end

    it "redirects to the right host, preserves the path" do
      request.host = "example.com"
      get :index, params: { foo: 'bar' }
      expect(response).to be_redirect
      expect(response.location).to include(host_setting.value)
      expect(response.location).to include("foo=bar")
    end

  end

end
