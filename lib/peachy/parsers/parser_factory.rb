module Peachy
  module Parsers
    class ParserFactory
      # Loads the first available XML parser defined in the list of parsers that
      # Peachy can use.  This requires the Gem for the parser and creates the method
      # make_from, which will return a new instance of the ParserWrapper for that
      # library.
      # In order of preference, the Gems that Peachy can currently use for parsing
      # XML are:
      #   * Nokogiri
      #   * REXML
      def load_parser
        preferred_parser = Parsers.find {|parser| Gem.available? parser[:gem] }
        self.class.class_eval do
          define_method(:make_from, preferred_parser[:implementation])
        end
        require(preferred_parser[:gem])
      end

      private
      Parsers =
        [{:gem => 'nokogiri', :implementation => lambda {|xml| NokogiriWrapper.new(Nokogiri::XML(xml)) }},
         {:gem => 'rexml/document', :implementation => lambda {|xml| REXMLWrapper.new(REXML::Document.new(xml)) }}]
    end
  end
end