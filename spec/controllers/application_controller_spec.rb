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

  describe '#set_locale' do

    it "gets the default locale if no other info" do
      get :index
      expect(I18n.locale).to eq(:en)
    end

    it "respects the locale param, stores it in a cookie" do
      get :index, params: { locale: 'id' }
      expect(I18n.locale).to eq(:id)
      expect(cookies['locale']).to eq('id')
    end

    it "respects the locale stored in the cookie" do
      cookies['locale'] = 'vi'
      get :index
      expect(I18n.locale).to eq(:vi)
    end

    it "respects the current_user's locale" do
      user = FactoryBot.create :user, locale: 'id'
      sign_in user
      get :index
      expect(I18n.locale).to eq(:id)
    end

    it "reads the lang header" do
      request.headers.merge!({ 'HTTP_ACCEPT_LANGUAGE' => 'vi-vi' })
      get :index
      expect(I18n.locale).to eq(:vi)

      request.headers.merge!({ 'HTTP_ACCEPT_LANGUAGE' => 'id' })
      get :index
      expect(I18n.locale).to eq(:id)
    end

  end

end
