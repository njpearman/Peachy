class InvalidProxyParameters < Exception
  def initialize parameters_hash={}
    parameters_string = []
    parameters_hash.each {|pair| parameters_string << ":#{pair.first} = #{pair.last.nil?? 'nil' : pair.last}" }
    super <<MESSAGE
The parameters that you passed to the Proxy were invalid.
#{parameters_string.sort * "\n"}
MESSAGE
  end
end
