module Peachy
  class XmlParserFactory
    def load_parser
      return load_up(:nokogiri) if Gem.available? /nokogiri/
      require('rexml/document')
      return :rexml
    end

    private
    def load_up xml_parser
      require(xml_parser.to_s)
      return xml_parser
    end
  end
end