module Peachy
  module XmlNode
    private
    def clone
      ProxyFactory.create_from_element(node)
    end

    # Returns the name of the encapsulated node.
    def node_name
      node.name
    end

    # The encapsulated Nokogiri node, which is lazy loaded from the @xml instance
    # variable.
    def node
      raise InvalidProxyParameters.new(:xml => nil, :nokogiri => nil) if variables_are_nil?
      @node ||= create
    end

    def create
      Peachy::Parsers::NokogiriWrapper.new(Nokogiri::XML(@xml))
    end
  end
end
