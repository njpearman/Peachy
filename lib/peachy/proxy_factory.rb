module Peachy
  class ProxyFactory
    class << self
      def create_from_element match
        return create_proxy(match) if there_are_child_nodes?(match)
        return create_proxy_with_attributes(match) if node_has_attributes?(match)
        return create_content_child(match)
      end

      def node_has_attributes? match
        match.attribute_nodes.size > 0
      end

      # Determines whether the given element contains any child elements or not.
      # The choice of implementation is based on performance tests between using
      # XPath and a Ruby iterator.
      def there_are_child_nodes? match
        match.children.any? {|child| child.kind_of? Peachy::Parsers::NokogiriWrapper } #Nokogiri::XML::Element }
      end

      def create_content_child match
        SimpleContent.new(match.content, match.name)
      end

      def create_proxy match
        Proxy.new(match)
      end

      def create_proxy_with_attributes match
        ChildlessProxyWithAttributes.new(match)
      end
    end
  end
end
