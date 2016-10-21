# Shoplifty

This gem provides a rudimentary interface to Shopify's backend API by simulating a backend user authenticating via the web interface. The backend JSON endpoints can then be accessed easily.

Credit where credit is due, Martin Amps figured it out before me:
[Reverse engineering Shopify private APIs](http://ma.rtin.so/reverse-engineering-shopify-private-apis)

Couldn't have done it without his work, thanks!

## A word of warning

__This is a proof of concept, use at your own risk. It is not officially supported by Shopify, if you break anything it's entirely on you__

__UPDATE 2014-10-31: Shopify changed the backend API, so this README is partly outdated. @SebastianSzturo already fixed the authentication, but I have not yet checked the rest of the functionality. So handle with care.__

## Installation

Add this line to your application's Gemfile:

    gem 'shoplifty', :git => 'git://github.com/leobossmann/shoplifty.git'

And then execute:

    $ bundle

## Usage

Initialize the client:

    require 'shoplifty'
    shoplifty = Shoplifty.setup('shopname', 'username', 'password')

Now you can access backend resources:

    shoplifty.get('/admin/shop_policies.json')
    shoplifty.post('/admin/shop_policies.json', your_payload)

Have a look at what gets sent around in the backend with Firebug or similar tools, the Backend API is pretty straightforward.

As a rule of thumb, everything that is a list of similar items (countries, email_templates etc.) can be accessed this way.

## Mail Notifications

There is class called "MailNotifications" that provides easy access to shopify's email templates:

    email_template = Shoplifty::MailNotifications.new('order_confirmation')
    email_template.title = 'Test'
    email_template.body_html = 'Test'
    email_template.save

Some email templates are plain text:

    email_template.body = 'Plain body'

Mail notifications are:

* order_confirmation
* new_order_notification
* new_order_notification_mobile
* shipping_confirmation
* shipping_update
* contact_buyer
* order_cancelled
* customer_account_activation
* customer_password_reset
* customer_account_welcome
* fulfillment_request

There are other templates, look at the links to them in the Shopify admin.


## Cookie settings

The client will create a file called 'cookie_jar' in your app's directory, if you want to have it at another location you can pass in a different filename:

    shoplifty = Shoplifty.setup('shopname', 'username', 'password', :cookie_jar => 'something/different')


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
