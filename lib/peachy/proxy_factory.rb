module Peachy
  class ProxyFactory
    class << self
      def create_from_element match
        return create_proxy(match) if match.has_children?
        return create_proxy_with_attributes(match) if match.has_attributes?
        return create_content_child(match)
      end

      def create_content_child match
        SimpleContent.new(match)
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
