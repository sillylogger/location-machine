require 'rails_helper'

describe ChatsHelper do

  describe '#native_chat_url' do
    it 'returns correct url' do
      expect(helper.native_chat_url('facebook', '123')).to eq 'https://m.me/123'
      expect(helper.native_chat_url('whatsapp', '123')).to eq 'https://wa.me/123'
      expect(helper.native_chat_url('zalo', '123')).to     eq 'https://zalo.me/123'
    end

    it 'strips any zeroes, brackets or dashes' do
      expect(helper.native_chat_url('whatsapp', '+00123')).to eq 'https://wa.me/123'
      expect(helper.native_chat_url('whatsapp', '+62123')).to eq 'https://wa.me/62123'
      expect(helper.native_chat_url('whatsapp', '+621-2-3')).to eq 'https://wa.me/62123'
    end
  end

end
