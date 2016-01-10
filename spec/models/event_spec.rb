describe Event do

  describe ".active" do
    let(:active_event) { FactoryGirl.create :event, opens: 1.minute.ago, closes: 1.minute.from_now }
    let(:inactive_event) { FactoryGirl.create :event, opens: 2.minutes.ago, closes: 1.minute.ago }

    it "includes ongoing events" do
      expect(Event.active).to include(active_event)
    end

    it "excludes past events" do
      expect(Event.active).not_to include(inactive_event)
    end
  end

  describe ".before_create" do
    it "sets the opens & closes datetime to a 24 hour period" do
      event = Event.new name: "party"
      expect(event.opens).to be_nil
      expect(event.closes).to be_nil
      event.save
      expect(event.opens).to be_within(2.seconds).of(Time.zone.now)
      expect(event.closes).to be_within(2.seconds).of(24.hours.from_now)
    end
  end
  

end
