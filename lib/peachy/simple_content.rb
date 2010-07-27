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
      return morph_with_content(method_name, *args, &block) if used_as_array(method_name, block_given?, *args)
      super
    end

    private
    def morph_with_content method_name, *args, &block
      return morph_into_array(SimpleContent.new(@xml), method_name, *args, &block)
    end
  end
end
