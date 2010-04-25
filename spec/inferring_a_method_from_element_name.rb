describe "inferring a method from a simple element" do
  before(:each) do
    @nokogiri_for_test = Nokogiri::XML('<testnode>Check meh.</testnode>')
    @proxy = Peachy::Proxy.new @nokogiri_for_test
  end

  it "should defer method_missing to the base class implementation if arguments are passed with the missing method" do
    lambda { @proxy.my_call "argument" }.should raise_error NoMethodError
  end

  it "should defer method_missing to the base class implementation if block is given with method_missing" do
    lambda { @proxy.my_call() { puts "Blockhead." } }.should raise_error NoMethodError
  end

  it "should not expose the original method_missing alias publically" do
    @proxy.methods.include?('original_method_missing').should be_false
  end

  it 'should add a reader for the method to the underlying class if the method does map to underlying XML node' do
    @proxy.testnode
    @proxy.methods.include?('testnode').should be_true
  end

  it 'should define the method on an instance, not on the class' do
    @another_proxy = Peachy::Proxy.new @nokogiri_for_test
    @proxy.testnode
    @proxy.methods.include?('testnode').should be_true
    @another_proxy.methods.include?('testnode').should be_false
  end

  it "should return the node contents when the node isn't defined as a method and the contents of the node is at the lowest point of the tree" do
    @proxy.testnode.should == 'Check meh.'
  end

  it "should define a method that returns the node contents is at the lowest point of the tree" do
    contents_when_not_defined = @proxy.testnode
    contents_after_defined = @proxy.testnode
    contents_after_defined.should == 'Check meh.'
    contents_after_defined.should == contents_when_not_defined
  end
end
