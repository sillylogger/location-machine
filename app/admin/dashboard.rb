ActiveAdmin.register_page "Dashboard" do
  menu false

  content do
    columns do

      column do
        panel "Most recent Locations of #{Location.count}" do
          ul(class: 'compact') do
            Location.order(id: :desc).limit(5).map do |location|
              summary = "#{location.name} @ #{location.latitude}, #{location.longitude}"
              li link_to(summary, admin_location_path(location))
            end
          end
          a("See all Locations", href: admin_locations_path, class: "see-all")
        end

        panel "Most recent Users of #{User.count}" do
          ul(class: 'compact') do
            User.order(id: :desc).limit(5).map do |user|
              summary = "#{user.name} #{user.email} #{user.phone}"
              li link_to(summary, admin_user_path(user))
            end
          end
          a("See all Users", href: admin_users_path, class: "see-all")
        end
      end

      column do
        panel "Most recent Items of #{Item.count}" do
          ul(class: 'compact items') do
            Item.order(id: :desc).limit(5).map do |item|
              render 'item', item: item 
            end
          end
          a("See all Items", href: admin_items_path, class: "see-all")
        end
      end

    end
  end

end
