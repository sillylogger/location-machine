require 'rails_helper'

describe Credential do

  describe ".fetch(namespace, key)" do
    let(:secret) { "Secret" }

    it "pulls values from the Rails.application.credentials" do
      expect(Rails.application.credentials).to receive(:foo).and_return({ bar: secret })
      expect(Credential.fetch(:foo, :bar)).to eq(secret)
    end

    context "when a key is overridden by an ENV variable" do
      before { ENV['FOO_BAR'] = secret }
      after  { ENV.delete 'FOO_BAR' }

      it "doesn't bother with the Rails.application.credentials lookup" do
        expect(Rails.application.credentials).not_to receive(:foo)
        expect(Credential.fetch(:foo, :bar)).to eq(secret)
      end
    end
  end

end
