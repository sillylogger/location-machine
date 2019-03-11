module ChatsHelper
  def click_to_chat_btn(user:, item_id: nil)
    if user.phone.present?
      link_to('Click to chat', user_chats_path(user_id: user.id, item_id: item_id))
    end
  end

  def chat_item(type, text, id)
    path = get_chat_url(type, id)
    link_to(path, target: '_blank') do
      content_tag(:div, class: 'chat-items__item') do
        concat image_tag("#{type}.png" )
        concat content_tag(:div, text, class: 'chat-items__item__text')
      end
    end
  end

  def get_chat_url(type, id)
    case type
    when 'facebook'
      "https://m.me/#{id}"
    when 'whatsapp'
      "https://wa.me/#{id}"
    when 'zalo'
      "https://zalo.me/#{id}"
    end
  end
end
