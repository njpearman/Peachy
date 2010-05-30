module Peachy
  module Parsers
    class NokogiriWrapper < ParserWrapper
      include WithXPath
      
      def initialize nokogiri
        @nokogiri = nokogiri
      end

      # Runs the XPath for the method name against the underlying XML DOM,
      # returning nil if no element or attribute matching the method name is found
      # in the children of the current location in the DOM.
      def find_matches method_name
        matches = xpath(xpath_for(method_name))
        matches.any? ? matches : nil
      end

      def find_match_by_attributes method_name
        match = @nokogiri.attribute_nodes.find do |attribute|
          attribute if method_name.variations.include? attribute.name
        end
        match.nil? ? nil : make_from(match)
      end

      def has_children_and_attributes?
        has_children? and has_attributes?
      end

      # Determines whether the given element contains any child elements or not.
      # The choice of implementation is based on performance tests between using
      # XPath and a Ruby iterator.
      def has_children?
        @nokogiri.children.any? {|child| child.kind_of? Nokogiri::XML::Element }
      end

      def has_attributes?
        @nokogiri.attribute_nodes.size > 0
      end

      def content
        @nokogiri.content
      end

      def name
        @nokogiri.name
      end

      def to_s
        @nokogiri.to_s
      end

      private
      def xpath xpath
        @nokogiri.xpath(xpath).map{|noko_node| make_from(noko_node) }
      end

      def make_from child
        NokogiriWrapper.new(child)
      end
    end
  end
end