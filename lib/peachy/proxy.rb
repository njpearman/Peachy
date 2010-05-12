require 'rubygems'
require 'nokogiri'

module Peachy
  class Proxy
    alias_method :original_method_missing, :method_missing
    extend MethodMask
    include ConventionChecks, MorphIntoArray, MyMetaClass, NodeChildMatcher

    # This hides all public methods on the class except for 'methods', 'nil?'
    # 'respond_to?' and 'inspect', which I've found are too useful to hide for
    # the time being.
    hide_public_methods ['methods', 'nil?', 'respond_to?', 'inspect']

    # Takes either a string containing XML or a Nokogiri::XML::Element as the
    # single argument.
    def initialize xml_node
      @xml = xml_node if xml_node.kind_of? String
      @nokogiri_node = xml_node if xml_node.kind_of? Nokogiri::XML::Element
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
      original_method_missing method_name, args if args.any? or block_given?

      # try to create a method for the element
      child_proxy = generate_method_for_xml(MethodName.new(method_name))

      if !child_proxy.nil?
        # found a match, so flag as only child
        acts_as_only_child
        child_proxy
      elsif array_can?(method_name)
        # if child doesn't exist, see if the call might be a zero-argument
        # Array call.
        new_proxy = create_from_element(node)
        morph_into_array(new_proxy, method_name)
      else
        # no matches, so throw
        raise NoMatchingXmlPart.new(method_name, node_name)
      end
    end

    private
    def generate_method_for_xml method_name
      check_for_convention(method_name)
      attribute_content = create_method_for_attribute(method_name, node) if has_children_and_attributes?
      return attribute_content unless attribute_content.nil?
      matches = find_matches(method_name)
      matches.nil? ? nil : create_method_for_child_or_content(method_name, matches)
    end

    def create_method_for_child_or_content method_name, matches
      return create_from_element_list(method_name, matches) if matches.size > 1
      return create_from_element(matches[0]) {|child| define_child method_name, child }
    end

    def create_method_for_attribute method_name, node
      match = node.attribute(method_name.to_s)
      create_value(match) {|child| define_child(method_name, child) } unless match.nil?
    end

    def has_children_and_attributes?
      there_are_child_nodes?(node) and node_has_attributes?(node)
    end

    def create_from_element_list method_name, matches
        define_method(method_name) { return matches_to_array matches }
    end

    def matches_to_array matches
      matches.inject([]) {|array, child| array << create_from_element(child) }
    end

    def create_from_element match, &block
      return create_proxy(match, &block) if there_are_child_nodes?(match)
      return create_proxy_with_attributes(match, &block) if node_has_attributes?(match)
      return create_content_child(match, &block)
    end

    def node_has_attributes? match
      match.attribute_nodes.size > 0
    end

    # Determines whether the given element contains any child elements or not.
    # The choice of implementation is based on performance tests between using
    # XPath and a Ruby iterator.
    def there_are_child_nodes? match
      match.children.any? {|child| child.kind_of? Nokogiri::XML::Element }
    end

    def create_value match, &block
      create_child(match.content, &block)
    end
    
    def create_content_child match, &block
      create_child(SimpleContent.new(match.content, match.name), &block)
    end

    def create_proxy match, &block
      create_child(Proxy.new(match), &block)
    end

    def create_proxy_with_attributes match, &block
      create_child ChildlessProxyWithAttributes.new(match), &block
    end

    def create_child child
      yield child if block_given?
      return child
    end

    def define_child method_name, child
      define_method(method_name) { return child }
    end

    def define_method method_name, &block
      eval_on_singleton_class { define_method(method_name.to_sym, &block) }
      yield
    end
    
    def variables_are_nil?
      @xml.nil? and @nokogiri_node.nil?
    end

    def clone
      create_from_element(node)
    end
  end
end
