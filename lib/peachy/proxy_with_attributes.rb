module Peachy
  class ProxyWithAttributes < Proxy
    include StringStyler
    
    def value
      @nokogiri_node.content
    end

    def generate_method_for_xml method_name
      method_name_as_string = method_name.to_s
      check_for_convention(method_name_as_string)
      # do the attribute stuff
      match = @nokogiri_node.attribute(method_name_as_string)
      match = @nokogiri_node.attribute(as_camel_case(method_name_as_string)) if match.nil?
      return create_content(method_name_as_string, match) unless match.nil?
      create_method_for_child_or_content method_name
    end
  end
end
