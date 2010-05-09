require 'spec_helper'
require 'ruby-debug'

describe "nested elements should be handled corectly by Peachy" do
  before(:each) do
    @proxy = Peachy::Proxy.new '<root><first><second>Check meh.</second></first></root>'
  end

  it "should be able to dot through the DOM hierachy" do
    @proxy.root.first.second.should == 'Check meh.'
  end

  it "should define methods for the ancestors" do
    @proxy.root.first.second
    @proxy.root.methods.should include 'first'
    @proxy.root.first.methods.should include 'second'
  end
end

