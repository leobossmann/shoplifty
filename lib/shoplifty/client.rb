require 'mechanize'

module Shoplifty
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
  end
end
