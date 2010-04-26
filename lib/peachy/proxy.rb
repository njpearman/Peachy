require 'rubygems'
require 'nokogiri'

module Peachy
  class Proxy
    methods_to_hide = public_instance_methods.clone
    methods_to_hide.delete('methods')
    private *methods_to_hide
    alias_method :original_method_missing, :method_missing
    
    def initialize nokogiri_node
      @nokogiri_node = nokogiri_node
    end

    # Overloaded so that calls to methods representative of an XML element or
    # attribute can be generated dynamically.
    # For example, if a proxy is referenced in code as proxy.first_node, and
    # first_node does match a child of the DOM encapsulated by proxy, then
    # first_node will be generated on proxy.
    # However, if first_node does not represent a child in the underlying DOM
    # then the proxy will raise a NoMatchingXmlPart error.
    # The method name used to access an XML node has to follow the standard Ruby
    # convention for method names, i.e. ^[a-z]+(?:_[a-z]+)?{0,}$
    # Any calls that include arguments or a block will be defered to the default
    # implementation of method_missing
    def method_missing method_name, *args, &block
      original_method_missing method_name, args, &block if args.any? or block_given?
      generate_method_for_xml method_name
    end

    protected
    def generate_method_for_xml method_name
      method_name_as_string = method_name.to_s
      check_for_convention(method_name_as_string)
      create_method_for_child_or_content method_name
    end

    private
    def create_method_for_child_or_content method_name
      matches = find_matches(method_name.to_s)
      first_match = matches[0]
      return create_child_proxy(method_name, first_match) if there_are_no_child_nodes(first_match)
      return create_child_proxy_with_attributes(method_name, first_match) if node_has_attributes(first_match)
      return create_content(method_name, first_match)
    end

    def node_has_attributes match
      match.attribute_nodes.size > 0
    end

    def there_are_no_child_nodes match
      match.xpath('*[not(*)]').size > 0
    end

    def create_content method_name, match
      node_content = match.content
      define_method(method_name) { return node_content }
      return node_content
    end

    def create_child_proxy_with_attributes method_name, match
      child_proxy = ProxyWithAttributes.new(match)
      define_method(method_name) { return child_proxy }
      return child_proxy
    end

    def create_child_proxy method_name, match
      child_proxy = Proxy.new(match)
      define_method(method_name) { return child_proxy }
      return child_proxy
    end

    # Runs the xpath for the method name against the underlying XML DOM, raising
    # a NoMatchingXmlPart if no element or attribute matching the method name is
    # found in the children of the current location in the DOM.
    def find_matches method_name
      matches = @nokogiri_node.xpath(xpath_for(method_name))
      raise NoMatchingXmlPart.new(method_name) if matches.length < 1
      return matches
    end
    
    # I don't like this hacky way of getting hold of the eigenclass to define
    # a method, but it's better than instance_eval'ing a string to def a method.
    def define_method method_name, &block
      (class << self; self; end).class_eval do
        define_method method_name, &block
      end
    end

    def xpath_for method_name
      "./#{method_name}|./#{as_camel_case(method_name)}|./#{as_hyphen_separated(method_name)}"
    end
    
    def as_camel_case method_name
      method_name.capitalize.gsub(/_([a-z])/){|s| s.upcase}.delete('_')
    end

    def as_hyphen_separated method_name
      method_name.gsub(/_/, '-')
    end
    
    def check_for_convention method_name
      raise MethodNotInRubyConvention.new(method_name) unless matches_convention(method_name)
    end

    def matches_convention method_name
      method_name =~ /^[a-z]+(?:_[a-z]+)?{0,}$/
    end
  end
end
