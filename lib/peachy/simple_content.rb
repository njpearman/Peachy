module Peachy
  class SimpleContent
    include MorphIntoArray, MyMetaClass

    define_method(:name) { value }
    define_method(:node_name) { @xml.name }
    define_method(:to_s) { @xml.to_s }

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
