module Peachy
  module Parsers
    class ParserFactory
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