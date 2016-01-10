describe ApplicationController do

  describe "#index" do
    it "renders the index page" do
      get :index
      expect(response.status).to eq(200)
      expect(response.body).to   include("Ruang Bawah")
    end
  end

end

