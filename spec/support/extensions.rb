
def wait_until extra_long_timeout = nil

  extra_long_timeout ||= Capybara.default_max_wait_time

  Timeout.timeout(extra_long_timeout) do
    sleep(0.250) until yield
  end

end

