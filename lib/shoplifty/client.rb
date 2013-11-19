require 'mechanize'
require 'active_support/inflector'

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

  class Client
    def initialize(shopname, username, password, options = {})
      options = { :cookie_jar => 'cookie_jar' }.merge(options)
      admin_url = "https://#{shopname}.myshopify.com/admin"
      
      @agent = Mechanize.new
      
      if (File.exists?(options[:cookie_jar]))
        @agent.cookie_jar.load options[:cookie_jar]
      end

      admin_page = @agent.get(admin_url)
      
      # if not authorized request will be redirected to '/admin/auth/login'
      if admin_page.uri.path != '/admin'
        login_page = @agent.get(admin_url)
        login_page.form do |login_form|
          login_form.login = username
          login_form.password = password
        end.submit
      end
      
      auth_token = @agent.get('/admin/2/unsupported_browser_bypass').at('meta[@name="csrf-token"]')[:content]
      
      @agent.cookie_jar.save_as(options[:cookie_jar], :session => true)

      @headers = {
        'X-CSRF-Token' => auth_token,
        'X-Requested-With' => 'XMLHttpRequest',
        'Content-Type' => 'application/json'
      }
    end

    def get(url)
      JSON.parse @agent.get(url).body
    end

    def post(url, payload)
     @agent.post(url, payload.to_json, @headers)
    end

    def put(url, payload)
     @agent.put(url, payload.to_json, @headers)
    end

    def method_missing(m)
      raw_data = get("/admin/#{m}.json")
      processed_data = []

      raw_data[m.to_s].each do |n|
        processed_data << Shoplifty::ShopifyEntity.new(m, n)
      end

      processed_data
    end
  end

  class ShopifyEntity
    def initialize(entity, args = {})
      @entity = entity
      args.each do |k, v|
        # http://pullmonkey.com/2008/01/06/convert-a-ruby-hash-into-a-class-object/
        self.instance_variable_set("@#{k}", v)
        self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
        self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
      end
    end
    def save
      Shoplifty.client.put("/admin/#{@entity}/#{id}.json", { @entity.to_s.singularize => self })
    end
  end
end
