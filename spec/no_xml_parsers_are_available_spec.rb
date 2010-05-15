require 'spec_helper'

describe "no xml parsers are available" do
  before(:each) do
    Gem.stubs(:available?).returns(false)
    @factory = Peachy::XmlParserFactory.new
  end

  it "should blow up if no XML parsing library is available" do
    lambda { @factory.load_parser }.should raise_error NoXmlParserAvailable
  end
end

