describe ApplicationController do

  describe "#index" do
    let!(:party) { FactoryBot.create :party }

    it "renders the index page" do
      get :index

      expect(response.status).to eq(200)
      expect(response.body).to   include("ruang bawah")
    end

    it "only shows open parties" do
      get :index

      party_ids = assigns(:parties).map(&:id)
      expect(party_ids).to match_array(Party.active.pluck(:id))
    end
  end

end

