module Peachy
  class ProxyFactory
    class << self
      def create_from_element match, &block
        return create_proxy(match, &block) if there_are_child_nodes?(match)
        return create_proxy_with_attributes(match, &block) if node_has_attributes?(match)
        return create_content_child(match, &block)
      end

      def node_has_attributes? match
        match.attribute_nodes.size > 0
      end

      # Determines whether the given element contains any child elements or not.
      # The choice of implementation is based on performance tests between using
      # XPath and a Ruby iterator.
      def there_are_child_nodes? match
        match.children.any? {|child| child.kind_of? Nokogiri::XML::Element }
      end

      def create_value match, &block
        create_child(match.content, &block)
      end

      def create_content_child match, &block
        create_child(SimpleContent.new(match.content, match.name), &block)
      end

      def create_proxy match, &block
        create_child(Proxy.new(match), &block)
      end

      def create_proxy_with_attributes match, &block
        create_child ChildlessProxyWithAttributes.new(match), &block
      end

      def create_child child
        yield child if block_given?
        return child
      end
    end
  end
end
