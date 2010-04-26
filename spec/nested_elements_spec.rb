require 'spec_helper'
require 'ruby-debug'

describe "nested elements should be handled corectly by Peachy" do
  before(:each) do
    @nokogiri_for_test = Nokogiri::XML('<root><first><second>Check meh.</second></first></root>')
    @proxy = Peachy::Proxy.new @nokogiri_for_test
  end

  it "should be able to dot through the DOM hierachy" do
    puts @proxy.root
    puts @proxy.root.first
    puts @proxy.root.first.second
    
    @proxy.root.first.second.should == 'Check meh.'
  end
end

