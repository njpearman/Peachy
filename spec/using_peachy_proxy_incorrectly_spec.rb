describe "using Peachy::Proxy incorrectly" do
  before(:each) do
    @proxy = Peachy::Proxy.new :xml => '<testnode>Check meh.</testnode>'
  end

  it 'should raise a well written error if the method does not map to anything in the underlying XML node' do
    lambda { @proxy.missing }.should raise_error(NoMatchingXmlPart, 'missing is not contained as a child of this node.')
  end

  it "should raise an error if the method name is not in Ruby convention" do
    lambda { @proxy.testNode }.should raise_error MethodNotInRubyConvention, <<EOF
You've tried to infer testNode using Peachy, but Peachy doesn't currently like defining methods that break Ruby convention.
Please use methods matching ^[a-z]+(?:_[a-z]+)?{0,}$ and Peachy will try to do the rest with your XML.*/
EOF
  end

  it "should throw an InvalidProxyParameters error if no valid parameters were included in the initializer hash" do
    invalid_proxy = Peachy::Proxy.new Hash.new
    lambda { invalid_proxy.boom }.should raise_error InvalidProxyParameters, <<EOF
The parameters that you passed to the Proxy were invalid.
:nokogiri = nil
:xml = nil
EOF
  end
end

