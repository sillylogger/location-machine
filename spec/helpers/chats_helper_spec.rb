require 'rails_helper'

describe ChatsHelper, type: :helper do
  describe '#get_chat_url' do
    it 'returns correct url' do
      expect(helper.get_chat_url('facebook', '123')).to eq 'https://m.me/123'
      expect(helper.get_chat_url('whatsapp', '123')).to eq 'https://wa.me/123'
      expect(helper.get_chat_url('zalo', '123')).to eq 'https://zalo.me/123'
    end
  end
end
