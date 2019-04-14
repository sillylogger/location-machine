FactoryBot.define do

  sequence :email do |n|
    "#{User::TEMP_EMAIL_PREFIX}-#{n}-facebook.com"
  end

  sequence :phone do |n|
    "+62-812-0000-#{ n.to_s.rjust(4, "0") }"
  end

  factory :user do
    name          { "Tommy Sullivan" }
    email
    phone
    password      { "password" }
    avatar_url    { "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9JzMwMHB4JyB3aWR0aD0nMzAwcHgnICBmaWxsPSIjMDAwMDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgMTAwIDEwMCIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgMTAwIDEwMDsiIHhtbDpzcGFjZT0icHJlc2VydmUiPjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+Cgkuc3Qwe2ZpbGw6IzAwMDAwMDt9Cjwvc3R5bGU+PGc+PHBhdGggZD0iTTUwLjIsMTQuOGMxOS4zLDAsMzUsMTUuNywzNSwzNXMtMTUuNywzNS0zNSwzNXMtMzUtMTUuNy0zNS0zNVMzMC45LDE0LjgsNTAuMiwxNC44IE01MC4yLDQuOGMtMjQuOSwwLTQ1LDIwLjEtNDUsNDUgICBzMjAuMSw0NSw0NSw0NXM0NS0yMC4xLDQ1LTQ1Uzc1LjEsNC44LDUwLjIsNC44TDUwLjIsNC44eiI+PC9wYXRoPjwvZz48Zz48Y2lyY2xlIGN4PSIzMy4zIiBjeT0iMzYuNiIgcj0iNiI+PC9jaXJjbGU+PC9nPjxnPjxjaXJjbGUgY3g9IjY3LjIiIGN5PSIzNi42IiByPSI2Ij48L2NpcmNsZT48L2c+PGc+PHBhdGggY2xhc3M9InN0MCIgZD0iTTUwLjIsNzYuN2MtOS41LDAtMTguMi01LjYtMjIuNi0xNC41Yy0xLjEtMi4yLTAuMi00LjksMi4xLTZjMi4yLTEuMSw0LjktMC4yLDYsMi4xYzIuOSw1LjgsOC40LDkuNSwxNC41LDkuNSAgIGM2LDAsMTEuNi0zLjYsMTQuNC05LjRjMS4xLTIuMiwzLjgtMy4xLDYtMmMyLjIsMS4xLDMuMSwzLjgsMiw2QzY4LjMsNzEuMSw1OS43LDc2LjcsNTAuMiw3Ni43eiI+PC9wYXRoPjwvZz48L3N2Zz4=" }
    confirmed_at  { Time.zone.now }

    trait :with_admin do
      role        { User::ROLES[:admin] }
    end
  end

  factory :facebook_user, parent: :user do
    after :create do |user|
      create_list :identity, 1, user: user
    end
  end
end

