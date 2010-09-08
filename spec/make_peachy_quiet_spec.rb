require 'spec_helper'

describe 'Peacy can be quitened down when necessary' do
  before(:each) do
    @peachy_proxy = Peachy::Proxy.new '<xml />'
  end

  after(:each) do
    Peachy.be_loud
  end

  it "should know when it should be quiet" do
    Peachy.be_quiet
    Peachy.being_quiet?.should be_true
  end

  it "should know when to be loud" do
    Peachy.be_loud
    Peachy.being_quiet?.should be_false
  end

  it "should not blow up when it's told to be quiet" do
    Peachy.be_quiet
    @peachy_proxy.not_a_method.should be_nil
  end
end