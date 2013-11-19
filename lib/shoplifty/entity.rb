module Shoplifty
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