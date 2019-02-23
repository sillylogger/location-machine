ActiveAdmin.register_page "Dashboard" do
  menu false

  content do
    columns do

      column do
        panel "Locations of #{Location.count}" do
          ul(class: 'compact') do
            Location.order(id: :desc).limit(5).map do |location|
              summary = "#{location.name} @ #{location.latitude}, #{location.longitude}"
              li link_to(summary, admin_location_path(location))
            end
          end
        end

        panel "Users of #{User.count}" do
          ul(class: 'compact') do
            User.order(id: :desc).limit(5).map do |user|
              summary = "#{user.name} #{user.email} #{user.phone}"
              li link_to(summary, admin_user_path(user))
            end
          end
        end
      end

      column do
        panel "Items of #{Item.count}" do
          ul(class: 'compact') do
            Item.order(id: :desc).limit(5).map do |item|
              summary = "#{item.name} #{number_to_currency(item.price)}"
              li link_to(summary, admin_item_path(item))
            end
          end
        end
      end

    end
  end

end
