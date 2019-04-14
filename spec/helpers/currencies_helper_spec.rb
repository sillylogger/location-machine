require 'rails_helper'

describe CurrenciesHelper do

  describe "#to_currency" do
    it "uses zero for amount for new objects" do
      expect(helper.to_currency(nil)).to eq("$0.00")
    end
  end

end
