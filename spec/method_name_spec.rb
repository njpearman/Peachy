require 'spec_helper'

describe "Peachy::MethodName" do
  before(:each) do
    @method_name = Peachy::MethodName.new 'method_name'
  end

  it "should return the original string as to_s" do
    @method_name.to_s.should == "method_name"
  end

  it "should return the expected symbol as to_sym" do
    @method_name.to_sym.should == :method_name
  end

  it "should return the expected number of variations in format" do
    @method_name.variations.size.should == 4
  end

  it "should return the expected variation formats" do
    variations = @method_name.variations

    variations.should include('method_name')
    variations.should include('methodName')
    variations.should include('method-name')
    variations.should include('MethodName')
  end

  it "should be possible to create a MethodName from a symbol" do
    @method_name = Peachy::MethodName.new :this_method
    variations = @method_name.variations

    @method_name.to_s.should == 'this_method'
    @method_name.to_sym.should == :this_method
    
    variations.should include('this_method')
    variations.should include('thisMethod')
    variations.should include('this-method')
    variations.should include('ThisMethod')
  end

  it "should be possible to indicate namespaces correctly" do
    method_name = Peachy::MethodName.new 'namespaceNSmethod_name'
    variations = method_name.variations

    method_name.to_s.should == 'namespaceNSmethod_name'
    method_name.to_sym.should == :namespaceNSmethod_name

    variations.should include('namespace:method_name')
    variations.should include('Namespace:MethodName')
    variations.should include('namespace:methodName')
    variations.should include('namespace:method-name')
  end

  it "should be possible to indicate multi-word namespaces correctly" do
    method_name = Peachy::MethodName.new 'my_namespaceNSmethod_name'
    variations = method_name.variations

    method_name.to_s.should == 'my_namespaceNSmethod_name'
    method_name.to_sym.should == :my_namespaceNSmethod_name

    variations.should include('my_namespace:method_name')
    variations.should include('MyNamespace:MethodName')
    variations.should include('myNamespace:methodName')
    variations.should include('my-namespace:method-name')
  end

  it "should not include duplicates in variations" do
    @method_name = Peachy::MethodName.new :method
    variations = @method_name.variations

    variations.size.should == 2
    variations.should include('method')
    variations.should include('Method')
  end

  it "should know how to check for convention" do
    @method_name = Peachy::MethodName.new('method_name')
    @method_name.check_for_convention.should be_nil
  end

  it "should know what a namespace indicator is" do
    @method_name = Peachy::MethodName.new('methodNSname')
    @method_name.check_for_convention.should be_nil
  end

  it "should only allow one namespace indicator" do
    @method_name = Peachy::MethodName.new('multiNSmethodNSname')
    lambda { @method_name.check_for_convention }.should raise_error(MethodNotInRubyConvention)
  end

  it "should know when a method name does not match the accepted convention" do
    method_name = Peachy::MethodName.new('method_Name')
    lambda { method_name.check_for_convention }.should raise_error(MethodNotInRubyConvention)
  end
end

class MultipleNamespacesNotAllowed < Exception
  def initialize method_name
  end
end
