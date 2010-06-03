module Peachy
  module ChildlessProxyWithAttributes
    # Returns the text content of the XML node encapsulated by this instance.
    def value
      acts_as_only_child
      node.content
    end

    private
    # The implementation for Proxy#generate_method_for_xml is far more straightforward
    # when the underlying element is a childless element that has attributes.
    def generate_method_for_xml method_name
      method_name.check_for_convention
      Peachy::Proxy::CurrentMethodCall.new(self, method_name).create_method_for_attribute {|match| no_matching_xml(method_name) if match.nil? }
    end
  end
end