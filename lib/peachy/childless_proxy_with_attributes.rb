module Peachy
  class ChildlessProxyWithAttributes < Proxy
    include StringStyler
    
    def value
      @nokogiri_node.content
    end

    private
    def generate_method_for_xml method_name
      check_for_convention(method_name)
      # do the attribute stuff.  this isn't very elegant...
      match = find_match_by_attributes method_name, nokogiri_node
      raise NoMatchingXmlPart.new method_name if match.nil?
      return create_content_child(method_name, match)
    end

    def find_match_by_attributes method_name, node
      mapped = method_name.variations.map {|variation| node.attribute variation }
      mapped.find{|match| match != nil }
    end
  end
end