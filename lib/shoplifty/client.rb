require 'mechanize'
require 'active_support/inflector'

module Shoplifty
  class Client
    def initialize(shopname, username, password, options = {})
      options = { :cookie_jar => 'cookie_jar' }.merge(options)
      admin_url = "https://#{shopname}.myshopify.com/admin/auth/login"
      
      @agent = Mechanize.new
      
      if (File.exists?(options[:cookie_jar]))
        @agent.cookie_jar.load options[:cookie_jar]
      end

      @agent.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10) AppleWebKit/600.1.25 (KHTML, like Gecko) Version/8.0 Safari/600.1.25"
      @agent.request_headers = { "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" } # Shopify Server checks that
      @agent.redirect_ok = true
      
      admin_page = @agent.get(admin_url)
      
      begin
        login_page = page.form_with(action: /login/) {|form| form.login = username; form.password = password }.submit
      rescue Mechanize::ResponseCodeError => exception
        if exception.response_code == '403'
          login_page = exception.page
        else
          raise # Some other error, re-raise
        end
      end
      
      auth_token = Nokogiri::HTML(login_page.body).css("meta[name='csrf-token']").first['content']
      
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
end
