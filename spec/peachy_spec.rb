require 'spec_helper'

describe Peachy do
  it "should allow the creation of a new Proxy" do
    proxy = Peachy.proxy '<test>Hello</test>'
    proxy.test.value.should == 'Hello'
  end
end

