module ChatsHelper
  def link_to_chat(user:, regarding:)
    return unless user.phone.present?

    link_to('Click to Chat', user_chats_path(user_id: user.id, regarding: regarding))
  end

  def chat_link(url:, label_text:, asset: )
    tag.li class: 'chat-links__link' do
      link_to(url, target: '_blank') do
        concat icon(asset, class: 'chat-links__icon m--clickable')
        concat tag.span(label_text, class: 'chat-links__text')
      end
    end
  end

  def native_chat_url messenger, id, regarding: nil
    normalized = id.gsub(/\-|\+/, '').sub(/^0*/, '')
    text_parameter = ""

    if regarding.present?
      text_parameter = "?text=#{ ERB::Util.url_encode(regarding) }"
    end

    case messenger
    when 'facebook'
      "https://m.me/#{normalized}"
    when 'whatsapp'
      # https://faq.whatsapp.com/en/android/26000030/
      "https://wa.me/#{normalized}#{text_parameter}"
    when 'zalo'
      "https://zalo.me/#{normalized}"
    end
  end

end
