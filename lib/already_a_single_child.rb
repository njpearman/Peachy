class AlreadyASingleChild < Exception
  def initialize node_name
    super <<MESSAGE
The '#{node_name}' node has already been accessed as a single child, but you are now trying to use it as a collection.
Do not try to access Peachy::Proxies in a mixed manner in your implementation.
MESSAGE
  end
end
