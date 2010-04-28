module Peachy
  class ChildlessProxyWithAttributes < Proxy
    include StringStyler
    
    def value
      @nokogiri_node.content
    end

    private
    def generate_method_for_xml method_name
      method_name_as_string = method_name.to_s
      check_for_convention(method_name_as_string)
      # do the attribute stuff.  this isn't very elegant...
      match = find_match_by_attributes method_name_as_string, nokogiri_node
      raise NoMatchingXmlPart.new method_name if match.nil?
      return create_content_child(method_name_as_string, match)
    end

    def find_match_by_attributes method_name, node
      match = node.attribute(method_name)
      match = node.attribute(as_camel_case(method_name)) if match.nil?
      return match
    end
  end
end