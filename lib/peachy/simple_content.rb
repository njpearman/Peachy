module Peachy
  class SimpleContent
    alias_method :original_method_missing, :method_missing
    attr_reader :node_name
    include MorphIntoArray, MyMetaClass
    [:to_s, :name].each {|method_name| define_method(method_name) { value } }

    def initialize value, node_name
      @value = value
      @node_name = node_name
    end

    def value
      acts_as_only_child
      @value
    end

    def method_missing method_name, *args, &block
      if you_use_me_like_an_array(method_name, block_given?, *args)
        new_content = SimpleContent.new(@value, @node_name)
        return morph_into_array(new_content, method_name, *args, &block)
      end
      original_method_missing method_name, *args
    end
  end
end
