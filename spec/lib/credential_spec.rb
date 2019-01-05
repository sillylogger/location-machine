require 'rails_helper'

describe Credential do

  describe ".fetch(namespace, key)" do
    it "pulls values from the Rails.application.credentials" do
      skip "TODO: for README.md"
    end

    context "when a key is overridden by an environment variable" do
      it "doesn't bother with the Rails.application.credentials lookup" do
        skip "TODO: for README.md"
      end
    end
  end

end
