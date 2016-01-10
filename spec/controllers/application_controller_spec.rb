describe ApplicationController do

  describe "#index" do
    let!(:event) { FactoryGirl.create :event }

    it "renders the index page" do
      get :index

      expect(response.status).to eq(200)
      expect(response.body).to   include("ruang bawah")
    end

    it "only shows open events" do
      get :index

      event_ids = assigns(:events).map(&:id)
      expect(event_ids).to match_array(Event.active.pluck(:id))
    end
  end

end

