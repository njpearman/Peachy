module Peachy
  module Parsers
    class ParserFactory
      def load_parser
        return load_up(:nokogiri) if Gem.available? /nokogiri/
        require('rexml/document')
        @@parser = :rexml
      end

      def make_from raw_xml
        return NokogiriWrapper.new(Nokogiri::XML(raw_xml)) if @@parser == :nokogiri
        return REXMLWrapper.new(REXML::Document.new(raw_xml)) if @@parser == :rexml
      end

      private
      def load_up xml_parser
        require(xml_parser.to_s)
        @@parser = xml_parser
      end
    end
  end
end