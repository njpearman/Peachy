class NoMatchingXmlPart < Exception
  def initialize method_name
    super "#{method_name} is not contained as a child of this node."
  end
end
