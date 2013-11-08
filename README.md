# Shoplifty

This gem provides a rudimentary interface to Shopify's backend API by simulating a backend user authenticating via the web interface. The backend JSON endpoints can then be accessed easily.

__This is a proof of concept, use at your own risk.__

## Installation

Add this line to your application's Gemfile:

    gem 'shoplifty', :git => 'git://github.com/leobossmann/shoplifty.git'

And then execute:

    $ bundle

## Usage

Initialize the client:

    require 'shoplifty'
    shoplifty = Shoplifty::Client.new('shopname', 'username', 'password')

Now you can access backend resources:

    shoplifty.get('/admin/shop_policies.json')
    shoplifty.post('/admin/shop_policies.json', your_payload)

Have a look at what gets sent around in the backend with Firebug or similar tools, the Backend API is pretty straightforward.

The client will create a file called 'cookie_jar' in your app's directory, if you want to have it at another location you can pass in a different filename:

    client.Shoplifty::Client.new('shopname', 'username', 'password', :cookie_jar => 'something/different')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
