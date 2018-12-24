
def wait_until extra_long_timeout = nil

  extra_long_timeout ||= Capybara.default_max_wait_time

  Timeout.timeout(extra_long_timeout) do
    sleep(0.250) until yield
  end

end

module Devise
  module Test
    module ViewHelpers
      extend ActiveSupport::Concern

      included do
        helper do
          # https://stackoverflow.com/questions/14426746/testing-devise-views-with-rspec/31595147

          def resource_name
            :user
          end

          def resource
            @resource ||= User.new
          end

          def devise_mapping
            @devise_mapping ||= Devise.mappings[:user]
          end

        end
      end

    end
  end
end

