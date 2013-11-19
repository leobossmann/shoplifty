require "shoplifty/version"
require "shoplifty/client"
require "shoplifty/shopify_entity"
require "shoplifty/mail_notifications"


module Shoplifty
  class << self
    def setup(shopname, username, password, options = {})
      Shoplifty.client = Shoplifty::Client.new(shopname, username, password, options)
    end
    def client
      @client
    end

    def client=(client)
      @client = client
    end
  end
end
