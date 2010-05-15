module Peachy
  class XmlParserFactory
    def load_parser
      return load_up(:nokogiri) if Gem.available? /nokogiri/
      return load_up(:libxml) if Gem.available? /libxml/
      raise NoXmlParserAvailable.new
    end

    private
    def load_up xml_parser
      require(xml_parser.to_s)
      return xml_parser
    end
  end
end