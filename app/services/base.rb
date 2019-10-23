class Base
  def self.call(*args)
    service = self.new(*args)
    service.call
    service
  end
end
