module Peachy
  module NodeChildMatcher
    # Runs the XPath for the method name against the underlying XML DOM,
    # returning nil if no element or attribute matching the method name is found
    # in the children of the current location in the DOM.
    def find_matches method_name #, node #=nokogiri_node
      matches = node.xpath(xpath_for(method_name))
      return nil if matches.length < 1
      return matches
    end

    def find_match_by_attributes method_name #, node
      mapped = method_name.variations.map {|variation| node.attribute variation }
      mapped.find {|match| match != nil }
    end

    # Gets the XPath for all variations of the MethodName instance
    def xpath_for method_name
      method_name.variations.map {|variation| "./#{variation}" } * '|'
    end

    # Returns the name of the encapsulated node.
    def node_name
      node.name
    end

    # The encapsulated Nokogiri node, which is lazy loaded from the @xml instance
    # variable.
    def node
      raise InvalidProxyParameters.new(:xml => nil, :nokogiri => nil) if variables_are_nil?
      @nokogiri_node ||= Nokogiri::XML(@xml)
    end
  end
end
