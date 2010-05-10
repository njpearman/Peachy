class NoMatchingXmlPart < Exception
  def initialize method_name, node_name
    super "#{method_name} is not contained as a child of the node #{node_name}."
  end
end
