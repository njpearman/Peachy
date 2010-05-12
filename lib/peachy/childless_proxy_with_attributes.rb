module Peachy
  class ChildlessProxyWithAttributes < Proxy
    # Returns the text content of the XML node encapsulated by this instance.
    def value
      acts_as_only_child
      node.content
    end

    private
    def generate_method_for_xml method_name
      check_for_convention(method_name)
      match = find_match_by_attributes method_name
      raise NoMatchingXmlPart.new method_name, node_name if match.nil?
      return create_value(match) {|child| define_child method_name, child }
    end
  end
end