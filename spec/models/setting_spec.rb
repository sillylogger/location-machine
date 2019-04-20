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
  end

  describe ".fetch" do
    it "returns the value for the name" do
      setting = Setting.create(name: 'foo', value: 'bar')
      expect(Setting.fetch('foo')).to eq('bar')
    end

    it "just returns nil if the name isn't found and a default isn't given" do
      # TODO: capturing exceptions here helps when setting up the app from nil...
      # but is it hiding the source of issues? :-/
      expect(Setting.fetch('foo')).to be_nil
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

  describe ".get" do
    it "returns the value for the name" do
      setting = Setting.create(name: 'foo', value: 'bar')
      expect(Setting.get('foo')).to eq('bar')
    end

    it "just returns nil if the name isn't found" do
      expect(Setting.get('foo')).to be_nil
    end
  end

  describe ".set" do
    it "updates a value (for tests)" do
      Setting.fetch "foo", "bar"
      expect(Setting.get("foo")).to eq("bar")
      Setting.set "foo", "bang"
      expect(Setting.get("foo")).to eq("bang")
    end

    context "when it doesn't yet exist" do
      it "creates the entry" do
        expect(Setting.get("foo")).to be_nil 
        Setting.set "foo", "bar"
        expect(Setting.get("foo")).to eq("bar")
      end
    end
  end

end
