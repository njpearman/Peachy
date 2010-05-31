module Peachy
  class SimpleContent
    include MorphIntoArray, MyMetaClass

    [:name, :to_s].each {|method| define_method(method) { @xml.send(method) }}

    def initialize xml
      @xml = xml
    end

    def value
      acts_as_only_child
      @xml.content
    end

    def method_missing method_name, *args, &block
      if you_use_me_like_an_array(method_name, block_given?, *args)
        new_content = SimpleContent.new(@xml)
        return morph_into_array(new_content, method_name, *args, &block)
      end
      super
    end
  end
end
