# Shoplifty

This gem provides a rudimentary interface to Shopify's backend API by simulating a backend user authenticating via the web interface. The backend JSON endpoints can then be accessed easily.

Credit where credit is due, Martin Amps figured it out before me:
[Reverse engineering Shopify private APIs](http://ma.rtin.so/reverse-engineering-shopify-private-apis)

Couldn't have done it without his work, thanks!

## A word of warning

__This is a proof of concept, use at your own risk. It is not officially supported by Shopify, if you break anything it's entirely on you__

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

you also can access (some) resources like this (Warning: This does *not* work for all resources, YMMV)

    last_email_template = shoplifty.email_templates.last

    => #<Shoplifty::ShopifyEntity:0x00000001234567
     @body="Plain text",
     @body_html="<h1>Look at me, I'm HTML!</h1>",
     @entity=:email_templates,
     @id=123456,
     @include_html=true,
     @name="Fulfillment Request",
     @title="Order Fulfillment Request for {{ shop_name }}">

    last_email_template.body = 'This is another plain text'
    last_email_template.save

As a rule of thumb, everything that is a list of similar items (countries, email_templates etc.) can be accessed this way.

## Mail Notifications

There is class called "MailNotifications" that provides easy access to shopify's email templates:

    email_templates = Shoplifty::MailNotifications.new
    email_templates.fulfillment_request.body = 'Test again'
    email_templates.fulfillment_request.save

Mail notifications, as of now, are:

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


## Cookie settings

The client will create a file called 'cookie_jar' in your app's directory, if you want to have it at another location you can pass in a different filename:

    shoplifty = Shoplifty.setup('shopname', 'username', 'password', :cookie_jar => 'something/different')


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
