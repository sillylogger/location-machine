require 'rails_helper'

describe ChatsHelper do

  describe "#native_chat_url" do
    it "returns correct url" do
      expect(helper.native_chat_url('facebook', '123')).to eq 'https://m.me/123'
      expect(helper.native_chat_url('whatsapp', '123')).to eq 'https://wa.me/123'
      expect(helper.native_chat_url('zalo', '123')).to     eq 'https://zalo.me/123'
    end

    it "strips any zeroes, brackets or dashes" do
      expect(helper.native_chat_url('whatsapp', '+00123')).to eq 'https://wa.me/123'
      expect(helper.native_chat_url('whatsapp', '+62123')).to eq 'https://wa.me/62123'
      expect(helper.native_chat_url('whatsapp', '+621-2-3')).to eq 'https://wa.me/62123'
    end

    it "adds the regarding text if supplied" do 
      expect(helper.native_chat_url('whatsapp', '+00123', regarding: 'foo bar')).to include('text=')
      expect(helper.native_chat_url('whatsapp', '+00123', regarding: 'foo bar')).to include('foo%20bar')
    end
  end

end
