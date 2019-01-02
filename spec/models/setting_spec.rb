require 'rails_helper'

describe Setting do

  describe "validations" do
    let(:setting) { Setting.create(name: 'foo', value: 'bar') }

    it "validates presence of name" do
      expect(setting).to be_valid
      setting.name = ""
      expect(setting).to be_invalid
      expect(setting.errors[:name].size).to eq(1)
    end

    it "validates presence of value" do
      expect(setting).to be_valid
      setting.value = ""
      expect(setting).to be_invalid
      expect(setting.errors[:value].size).to eq(1)
    end
  end

  describe ".fetch" do
    it "returns the value for the name" do
      setting = Setting.create(name: 'foo', value: 'bar')
      expect(Setting.fetch('foo')).to eq('bar')
    end

    it "throws an exception if the name isn't found and a default isn't given" do
      expect {
        Setting.fetch('foo')
      }.to raise_error(KeyError)
    end

    it "returns the default if the name isn't found and a default is given" do
      expect(Setting.fetch('foo', 'bar')).to eq('bar')
    end

    it "creates a setting if the name isn't found and a default is given" do
      expect {
        expect(Setting.fetch('foo', 'bar')).to eq('bar')
      }.to change(Setting, :count).by(1)
    end
  end

end
