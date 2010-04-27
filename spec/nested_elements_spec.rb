require 'spec_helper'
require 'ruby-debug'

describe "nested elements should be handled corectly by Peachy" do
  before(:each) do
    @proxy = Peachy::Proxy.new :xml => '<root><first><second>Check meh.</second></first></root>'
  end

  it "should be able to dot through the DOM hierachy" do
    @proxy.root.first.second.should == 'Check meh.'
  end
end

