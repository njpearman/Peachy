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

    def method_missing method_name, *args
      return morph_into_array(SimpleContent.new(@value, @node_name)) if you_use_me_like_an_array(method_name, *args)
      original_method_missing method_name, *args
    end
  end
end
