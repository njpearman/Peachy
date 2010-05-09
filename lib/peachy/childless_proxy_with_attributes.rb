module Peachy
  class ChildlessProxyWithAttributes < Proxy
    def value
      acts_as_only_child
      @nokogiri_node.content
    end

    private
    def generate_method_for_xml method_name
      check_for_convention(method_name)
      match = find_match_by_attributes method_name, nokogiri_node
      raise NoMatchingXmlPart.new method_name if match.nil?
      return create_value(match) {|child| define_child method_name, child }
    end

    def find_match_by_attributes method_name, node
      mapped = method_name.variations.map {|variation| node.attribute variation }
      mapped.find {|match| match != nil }
    end
  end
end