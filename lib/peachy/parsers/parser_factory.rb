module Peachy
  module Parsers
    class ParserFactory
      Parsers = 
        [['nokogiri', lambda {|xml| NokogiriWrapper.new(Nokogiri::XML(xml)) }],
         ['rexml/document', lambda {|xml| REXMLWrapper.new(REXML::Document.new(xml)) }]]
      
      def load_parser
        preferred_parser = get_preferred_parser
        self.class.class_eval do
          define_method(:make_from, preferred_parser.last)
        end
        require(preferred_parser.first)
      end

      private
      def get_preferred_parser
        Parsers.find {|parser| Gem.available? parser.first }
      end
    end
  end
end