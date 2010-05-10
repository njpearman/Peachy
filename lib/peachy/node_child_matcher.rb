module Peachy
  module NodeChildMatcher
    # Runs the xpath for the method name against the underlying XML DOM, raising
    # a NoMatchingXmlPart if no element or attribute matching the method name is
    # found in the children of the current location in the DOM.
    def find_matches method_name, node #=nokogiri_node
      matches = node.xpath(xpath_for(method_name))
      return nil if matches.length < 1
      return matches
    end

    def find_match_by_attributes method_name, node
      mapped = method_name.variations.map {|variation| node.attribute variation }
      mapped.find {|match| match != nil }
    end

    # Gets the XPath for all variations of the MethodName instance
    def xpath_for method_name
      method_name.variations.map {|variation| "./#{variation}" } * '|'
    end
  end
end
