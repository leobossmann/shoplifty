module Shoplifty
  class MailNotifications
    def initialize(template)
      @email_form = Shoplifty::client.agent.get("/admin/email_templates/#{template}/edit").form_with(action: /email_templates/)
    end

    def title=(value)
      email_field('title', value)
    end

    def body_html=(value)
      email_field('body_html', value)
    end

    def body=(value)
      email_field('body', value)
    end

    def email_field(field, value)
      @email_form.field_with(name: "email_template[#{field}]") {|field| field.value = value}
    end

    def save
      @email_form.submit
    end
  end
end
