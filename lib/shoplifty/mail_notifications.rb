module Shoplifty
  class MailNotifications
    def initialize()
      @notifications = {}
      raw_notifications = Shoplifty::client.get('/admin/email_templates.json')
      raw_notifications['email_templates'].each do |n|
        @notifications[n['name'].underscore] = ShopifyEntity.new('email_templates', n)
      end
    end
    def method_missing(m)
      @notifications[m.to_s]
    end
  end
end