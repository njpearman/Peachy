class NoXmlParserAvailable < Exception
  def initialize
    super <<MESSAGE
Peachy was unable to find any XML parser gems.  PEachy expects one of the following
gems to be installed before use:
Nokogiri
LibXML
MESSAGE
  end
end
