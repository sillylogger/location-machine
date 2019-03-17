module ChatsHelper
  def link_to_chat(user:, item_id: nil)
    if user.phone.present?
      link_to('Click to Chat', user_chats_path(user_id: user.id, item_id: item_id))
    end
  end

  def native_chat_link(type:, id:, text:, asset: nil)
    url = native_chat_url(type, id)

    tag.li class: 'chat-links__link' do
      link_to(url, target: '_blank') do
        concat icon(asset, class: 'chat-links__icon m--clickable')
        concat tag.span(text, class: 'chat-links__text')
      end
    end
  end

  def native_chat_url type, id
    normalized = id.gsub(/\-|\+/, '').sub(/^0*/, '')

    case type
    when 'facebook'
      "https://m.me/#{normalized}"
    when 'whatsapp'
      # https://faq.whatsapp.com/en/android/26000030/
      "https://wa.me/#{normalized}"
    when 'zalo'
      "https://zalo.me/#{normalized}"
    end
  end

end
