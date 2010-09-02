describe "using Peachy::Proxy incorrectly" do
  before(:each) do
    @proxy = Peachy::Proxy.new '<testnode>Check meh.</testnode>'
  end

  it 'should return nil if the method does not map to anything in the underlying XML node' do
    @proxy.missing.nil?.should == true
  end

  it "should raise an error if the method name is not in Ruby convention" do
    expected_message = <<EOF
You've tried to infer testNode using Peachy, but Peachy doesn't currently like defining methods that break Ruby convention.
Please use methods matching ^[a-z]+(?:_[a-z]+)?{0,}$ and Peachy will try to do the rest with your XML.*/
EOF
    lambda { @proxy.testNode }.should raise_error(MethodNotInRubyConvention, expected_message)
  end

  it "should throw an InvalidProxyParameters error if an incorrect type of parameter was passed as the initializer argument" do
    expected_message = <<EOF
The parameters that you passed to the Proxy were invalid.
:nokogiri = nil
:xml = nil
EOF
    invalid_proxy = Peachy::Proxy.new Hash.new
    lambda { invalid_proxy.boom }.should raise_error(InvalidProxyParameters, expected_message)
  end
end

