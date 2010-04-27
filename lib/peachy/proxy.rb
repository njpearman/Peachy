require 'rubygems'
require 'nokogiri'

module Peachy
  class Proxy
    # This method hides all public methods on the class except for methods and
    # respond_to?, which i've found are too useful to hide for the time being.
    def self.hide_public_methods
      methods_to_hide = public_instance_methods.clone
      methods_to_hide.delete('methods')
      methods_to_hide.delete('respond_to?')
      private *methods_to_hide
    end
    
    alias_method :original_method_missing, :method_missing
    hide_public_methods

    include ConventionChecks, StringStyler

    # Takes a hash as an argument.  Valied keys are:
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

    protected
    def generate_method_for_xml method_name
      method_name_as_string = method_name.to_s
      check_for_convention(method_name_as_string)

      if nokogiri_node.children.size > 0
        match = nokogiri_node.attribute(method_name_as_string)
        return create_content_child(method_name_as_string, match) unless match.nil?
      end
      
      create_method_for_child_or_content method_name
    end

    def create_method_for_child_or_content method_name
      matches = find_matches(method_name.to_s)
      first_match = matches[0]
      create_from_element method_name, first_match
    end

    private
    def nokogiri_node
      raise InvalidProxyParameters.new(:xml => nil, :nokogiri => nil) if @xml.nil? and @nokogiri_node.nil?
      @nokogiri_node ||= Nokogiri::XML(@xml)
    end

    # Runs the xpath for the method name against the underlying XML DOM, raising
    # a NoMatchingXmlPart if no element or attribute matching the method name is
    # found in the children of the current location in the DOM.
    def find_matches method_name
      matches = nokogiri_node.xpath(xpath_for(method_name))
      raise NoMatchingXmlPart.new(method_name) if matches.length < 1
      return matches
    end

    def xpath_for method_name
      "./#{method_name}|./#{as_camel_case(method_name)}|./#{as_hyphen_separated(method_name)}"
    end

    def create_from_element method_name, match
      return create_child_proxy(method_name, match) if there_are_child_nodes(match)
      return create_child_proxy_with_attributes(method_name, match) if node_has_attributes(match)
      return create_content_child(method_name, match)
    end

    def node_has_attributes match
      match.attribute_nodes.size > 0
    end

    def there_are_child_nodes match
      match.xpath('./*').size > 0
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
