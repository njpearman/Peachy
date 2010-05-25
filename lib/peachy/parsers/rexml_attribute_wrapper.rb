module Peachy
  module Parsers
    class REXMLAttributeWrapper < ParserWrapper
      def initialize array
        @attribute = array
      end

      def content
        @attribute.last
      end

      def name
        @attribute.first
      end
    end
  end
end