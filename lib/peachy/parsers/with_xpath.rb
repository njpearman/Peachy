module Peachy
  module Parsers
    module WithXPath
      # Gets the XPath for all variations of the MethodName instance
      def xpath_for method_name
        method_name.variations.map {|variation| "./#{variation}" } * '|'
      end
    end
  end
end