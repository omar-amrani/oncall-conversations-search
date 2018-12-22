require 'intercom'
module IntercomClient
  class Client
    Intercom = Intercom::Client.new(token: ENV['INTERCOM_TOKEN'])
  end
end
