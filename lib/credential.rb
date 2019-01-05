class Credential

  def self.fetch namespace, key
    environment_variableified = [namespace, key].map(&:upcase).join('_')

    if ENV.has_key? environment_variableified
      ENV[environment_variableified]
    else
      Rails.application.credentials.send(namespace)[key]
    end

  rescue Exception => e
    puts "Missing Credential: #{namespace} - #{key}"
  end

end

