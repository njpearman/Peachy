require 'rubygems'
require 'nokogiri'

module Peachy
  class Proxy
    # This method hides all public methods on the class except for methods and
    # respond_to?, which i've found are too useful to hide for the time being.
    def self.hide_public_methods
      methods_to_hide = public_instance_methods.clone
      ['methods', 'respond_to?', 'inspect'].each {|to_stay_public| methods_to_hide.delete(to_stay_public)}
      private *methods_to_hide
    end
    
    alias_method :original_method_missing, :method_missing
    hide_public_methods

    include ConventionChecks, StringStyler

    # Takes a hash as an argument.  Valid keys are:
    #   :xml -
    #       used to pass raw XML into the Proxy, and the XML parser will be
    #       created on the fly.
    #   :nokogiri -
    #       can be used to pass in a Nokogiri::XML instance, if one has
    #       already been created.
    def initialize arguments
      @nokogiri_node = arguments[:nokogiri]
      @xml = arguments[:xml]
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
    # Any calls to undefined methods that include arguments or a block will be
    # deferred to the default implementation of method_missing.
    def method_missing method_name, *args, &block
      original_method_missing method_name, args, &block if args.any? or block_given?
      generate_method_for_xml method_name
    end

    private
    def generate_method_for_xml method_name
      method_name_as_string = method_name.to_s
      check_for_convention(method_name_as_string)

      attribute_content = create_from_parent_with_attribute method_name_as_string, nokogiri_node
      return attribute_content unless attribute_content.nil?
      
      create_method_for_child_or_content method_name, nokogiri_node
    end

    def nokogiri_node
      raise InvalidProxyParameters.new(:xml => nil, :nokogiri => nil) if variables_are_nil?
      @nokogiri_node ||= Nokogiri::XML(@xml)
    end

    def variables_are_nil?
      @xml.nil? and @nokogiri_node.nil?
    end

    def create_method_for_child_or_content method_name, node
      matches = find_matches(method_name.to_s, node)
      return create_from_element_list method_name, matches if matches.size > 1
      return create_from_element method_name, matches[0]
    end

    # Runs the xpath for the method name against the underlying XML DOM, raising
    # a NoMatchingXmlPart if no element or attribute matching the method name is
    # found in the children of the current location in the DOM.
    def find_matches method_name, node #=nokogiri_node
      matches = node.xpath(xpath_for(method_name))
      raise NoMatchingXmlPart.new(method_name) if matches.length < 1
      return matches
    end

    def xpath_for method_name
      "./#{method_name}|./#{as_camel_case(method_name)}|./#{as_hyphen_separated(method_name)}"
    end

    def create_from_parent_with_attribute method_name, node
      if there_are_child_nodes?(node) and node_has_attributes?(node)
        match = node.attribute(method_name)
        return create_content_child(method_name, match) unless match.nil?
      end
    end

    def create_from_element_list  method_name, matches
        items = []
        matches.each {|child| items << child.content }
        create_child(method_name, items)
    end

    def create_from_element method_name, match
      return create_child_proxy(method_name, match) if there_are_child_nodes?(match)
      return create_child_proxy_with_attributes(method_name, match) if node_has_attributes?(match)
      return create_content_child(method_name, match)
    end

    def node_has_attributes? match
      match.attribute_nodes.size > 0
    end

    # Determines whether the given element contains any child elements or not.
    # The choice of implementation is based on performance tests between using
    # XPath and a Ruby iterator.
    def there_are_child_nodes? match
      match.children.any? {|child| child.kind_of? Nokogiri::XML::Element}
    end

    def create_content_child method_name, match
      return create_child(method_name, match.content)
    end

    def create_child_proxy method_name, match
      return create_child(method_name, Proxy.new(:nokogiri => match))
    end

    def create_child_proxy_with_attributes method_name, match
      return create_child(method_name, ChildlessProxyWithAttributes.new(:nokogiri => match))
    end

    def create_child method_name, return_value
      return define_method(method_name) { return return_value }
    end

    # I don't like this hacky way of getting hold of the singleton class to define
    # a method, but it's better than instance_eval'ing a dynamic string to define
    # a method.
    def define_method method_name, &block
      get_my_singleton_class.class_eval do
        define_method method_name, &block
      end
      yield
    end

    def get_my_singleton_class
      (class << self; self; end)
    end
  end
end
