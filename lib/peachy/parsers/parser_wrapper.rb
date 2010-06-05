module Peachy
  module Parsers
    class ParserWrapper
      def create_from_element 
        return create_proxy if has_children?
        return create_proxy_with_attributes if has_attributes?
        return create_content_child
      end

      private
      def create_content_child 
        SimpleContent.new(self)
      end

      def create_proxy 
        Proxy.new(self)
      end

      def create_proxy_with_attributes 
        childless_proxy_with_attributes = Proxy.new(self)
        childless_proxy_with_attributes.instance_eval do
          (class << self; self; end).instance_eval do
            include ChildlessProxyWithAttributes
          end
        end
        return childless_proxy_with_attributes
      end
    end
  end
end
