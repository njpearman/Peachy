module Peachy
  class Proxy
    extend MethodMask
    include MorphIntoArray, MyMetaClass, XmlNode

    # This hides all public methods on the class except for 'methods', 'nil?'
    # 'respond_to?', 'inspect' and 'instance_eval', which I've found are too
    # useful / fundamental / dangerous to hide.
    hide_public_methods ['methods', 'nil?', 'respond_to?', 'inspect', 'instance_eval']

    # Takes either a string containing XML or a Nokogiri::XML::Element as the
    # single argument.
    def initialize xml_node
      @xml = xml_node if xml_node.kind_of? String
      @node = xml_node if xml_node.kind_of? Peachy::Parsers::ParserWrapper
    end

    def to_s
      return @xml unless @xml.nil?
      node.to_s
    end

    # Overloaded so that calls to methods representative of an XML element or
    # attribute can be generated dynamically.
    #
    # For example, if a proxy is referenced in code as proxy.first_node, and
    # first_node does match a child of the DOM encapsulated by proxy, then
    # first_node will be generated on proxy.
    #
    # However, if first_node does not represent a child in the underlying DOM
    # then proxy will raise a NoMatchingXmlPart error.
    #
    # The method name used to access an XML node has to follow the standard Ruby
    # convention for method names, i.e. ^[a-z]+(?:_[a-z]+)?{0,}$.  If an attempt
    # is made to call a method on a Peachy::Proxy that breaks this convention,
    # Peachy will simply raise a MethodNotInRubyConvention error.
    #
    # Collections are referenced as an array following the name of the individual
    # items of the collection.
    #
    # e.g.
    # xml = <<XML
    # <feed>
    #   <items>
    #     <item>Story 1</item>
    #     <item>Story 2</item>
    #     <item>Story 3</item>
    #   </items>
    # </feed>
    # XML
    # 
    # @proxy = Peachy::Proxy xml
    # @proxy.feed.items.item[0]
    # => Story 1
    # @proxy.feed.items.item[2]
    # => Story 3
    #
    # Note that Peachy will try to manage the case where a
    # single node is treated as the the first and only element in a collection.
    # In this case, the pattern above will apply.  Also, if an element is treated
    # as a single child, but later treated as if it should be part of a
    # collection, then an AlreadyASingleChild error will be raised.  You can't
    # expect a node to be both a single child AND a single element in a
    # collection.
    #
    # Any calls to undefined methods that include arguments or a block will be
    # deferred to the default implementation of method_missing.
    #
    def method_missing method_name, *args, &block
      # check whether an Array method is called with arguments or a block
      if you_use_me_like_an_array(method_name, block_given?, *args)
        return morph_into_array(clone, method_name, *args, &block)
      end

      # standard method_missing for any other call with arguments or a block
      super if args.any? or block_given?

      # try to create a method for the element
      child_proxy = generate_method_for_xml(MethodName.new(method_name))

      if !child_proxy.nil?
        # found a match, so flag as only child
        acts_as_only_child
        child_proxy
      elsif array_can?(method_name)
        # morph into an array, as method is a zero-length array call
        new_proxy = ProxyFactory.create_from_element(node)
        morph_into_array(new_proxy, method_name)
      else
        no_matching_xml(method_name)
      end
    end

    private
    def generate_method_for_xml method_name
      method_name.check_for_convention
      current_call = CurrentMethodCall.new(self, method_name)
      attribute_content = current_call.create_attribute
      return attribute_content unless attribute_content.nil?
      matches = current_call.find_matches
      matches.nil? ? nil : current_call.create_method_for_child_or_content(matches)
    end

    def variables_are_nil?
      @xml.nil? and @node.nil?
    end

    def no_matching_xml method_name
      raise NoMatchingXmlPart.new(method_name, name)
    end

    class CurrentMethodCall
      extend MethodMask
      include MyMetaClass, XmlNode
      
      def initialize proxy, method
        @method_name = method
        @proxy = proxy
      end
      
      def create_method_for_child_or_content matches
        return define_child_array(matches) if matches.size > 1
        child = ProxyFactory.create_from_element(matches[0])
        define_child_as(child)
      end

      def create_attribute
        create_method_for_attribute if @proxy.node.has_children_and_attributes?
      end

      def create_method_for_attribute
        match = find_match_by_attributes
        yield match if block_given?
        define_child_as(match.content) unless match.nil?
      end

      def find_matches
        @proxy.node.find_matches(@method_name)
      end

      def find_match_by_attributes
        @proxy.node.find_match_by_attributes(@method_name)
      end

      def define_child_array matches
        define_child(@method_name) { return CurrentMethodCall.matches_to_array(matches) }
      end

      def define_child_as child
        define_child(method_name) { return child }
      end

      def define_child method_name, &block
        @proxy.eval_on_singleton_class { define_method(method_name.to_sym, &block) }
        yield
      end

      private
      attr_reader :method_name

      def self.matches_to_array matches
        matches.inject([]) {|array, child| array << ProxyFactory.create_from_element(child) }
      end
    end
  end
end
