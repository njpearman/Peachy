module Peachy
  module XmlNode
    private
    def clone
      ProxyFactory.create_from_element(node)
    end

    # Returns the name of the encapsulated node.
    def name
      node.name
    end

    # The encapsulated Nokogiri node, which is lazy loaded from the @xml instance
    # variable.
    def node
      raise InvalidProxyParameters.new(:xml => nil, :nokogiri => nil) if variables_are_nil?
      @node ||= create
    end

    def create
      load_factory unless defined? @factory
      @factory.make_from @xml
    end

    private
    def load_factory
      @factory = Peachy::Parsers::ParserFactory.new
      @factory.load_parser
    end
  end
end
