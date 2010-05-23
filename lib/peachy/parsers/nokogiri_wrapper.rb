module Peachy
  module Parsers
    class NokogiriWrapper
      def initialize nokogiri
        @nokogiri = nokogiri
      end

      # Runs the XPath for the method name against the underlying XML DOM,
      # returning nil if no element or attribute matching the method name is found
      # in the children of the current location in the DOM.
      def find_matches method_name
        matches = xpath(xpath_for(method_name))
        return nil if matches.length < 1
        return matches
      end

      def find_match_by_attributes method_name
        mapped = method_name.variations.map {|variation| attribute(variation) }
        mapped.find {|match| match != nil }
      end

      def has_children_and_attributes?
        has_children? and has_attributes?
      end

      # Determines whether the given element contains any child elements or not.
      # The choice of implementation is based on performance tests between using
      # XPath and a Ruby iterator.
      def has_children?
        children.any? {|child| child.kind_of? Peachy::Parsers::NokogiriWrapper }
      end

      def has_attributes?
        attribute_nodes.size > 0
      end

      def content
        @nokogiri.content
      end

      def name
        @nokogiri.name
      end

      private
      def attribute_nodes
        @nokogiri.attribute_nodes.map {|attribute| attribute.content }
      end

      def children
        @nokogiri.children.map {|child| make_from(child) if child.kind_of? Nokogiri::XML::Element }
      end

      # Gets the XPath for all variations of the MethodName instance
      def xpath_for method_name
        method_name.variations.map {|variation| "./#{variation}" } * '|'
      end

      def xpath xpath
        @nokogiri.xpath(xpath).map{|noko_node| make_from(noko_node) }
      end

      def attribute attribute_name
        noko = @nokogiri.attribute(attribute_name)
        noko.nil? ? nil : make_from(noko)
      end

      def make_from child
        NokogiriWrapper.new(child)
      end
    end
  end
end