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
      create_method_for_attribute(method_name) {|match| no_matching_xml(method_name) if match.nil? }
    end
  end
end