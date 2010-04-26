module Peachy
  class ProxyWithAttributes < Proxy
    def value
      @nokogiri_node.content
    end
  end
end
