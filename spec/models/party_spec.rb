describe Party do

  describe ".active" do
    let(:active_party) { FactoryGirl.create :party, opens: 1.minute.ago, closes: 1.minute.from_now }
    let(:inactive_party) { FactoryGirl.create :party, opens: 2.minutes.ago, closes: 1.minute.ago }

    it "includes ongoing partys" do
      expect(Party.active).to include(active_party)
    end

    it "excludes past partys" do
      expect(Party.active).not_to include(inactive_party)
    end
  end

  describe ".before_create" do
    it "sets the opens & closes datetime to a 24 hour period" do
      party = Party.new name: "party"
      expect(party.opens).to be_nil
      expect(party.closes).to be_nil
      party.save
      expect(party.opens).to be_within(2.seconds).of(Time.zone.now)
      expect(party.closes).to be_within(2.seconds).of(24.hours.from_now)
    end
  end
  

end
