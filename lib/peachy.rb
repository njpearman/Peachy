require 'rubygems'

require File.join(File.dirname(__FILE__), 'already_an_only_child')
require File.join(File.dirname(__FILE__), 'invalid_proxy_parameters')
require File.join(File.dirname(__FILE__), 'method_not_in_ruby_convention')
require File.join(File.dirname(__FILE__), 'no_matching_xml_part')
require File.join(File.dirname(__FILE__), 'nothing_to_mimic')
require File.join(File.dirname(__FILE__), 'peachy/compatibility')
require File.join(File.dirname(__FILE__), 'peachy/string_styler')
require File.join(File.dirname(__FILE__), 'peachy/method_name')
require File.join(File.dirname(__FILE__), 'peachy/method_mask')
require File.join(File.dirname(__FILE__), 'peachy/mimic')
require File.join(File.dirname(__FILE__), 'peachy/morph_into_array')
require File.join(File.dirname(__FILE__), 'peachy/my_meta_class')
require File.join(File.dirname(__FILE__), 'peachy/xml_node')
require File.join(File.dirname(__FILE__), 'peachy/current_method_call')
require File.join(File.dirname(__FILE__), 'peachy/simple_content')
require File.join(File.dirname(__FILE__), 'peachy/parsers/parser_factory')
require File.join(File.dirname(__FILE__), 'peachy/parsers/parser_wrapper')
require File.join(File.dirname(__FILE__), 'peachy/parsers/nokogiri_wrapper')
require File.join(File.dirname(__FILE__), 'peachy/parsers/rexml_wrapper')
require File.join(File.dirname(__FILE__), 'peachy/parsers/rexml_attribute_wrapper')
require File.join(File.dirname(__FILE__), 'peachy/proxy')
require File.join(File.dirname(__FILE__), 'peachy/childless_proxy_with_attributes')

module Peachy
  # Tells Peachy to quietly return nil when an xml node is not found, rather than
  # throwing a NoMatchingXmlPart error.  Use this setting when you want to have a
  # conditional piece of logic with an XML node that may or may not exist.
  def self.be_quiet
    @quiet = true
  end

  # Tells Peachy to be loud about XML nodes that don't exist, by raising a
  # NoMatchingXmlPart error.  Use this setting when you want to know about any
  # XML nodes that unexpectedly don't exist.  This is the default setting, rather
  # than #be_quiet.
  def self.be_loud
    @quiet = false
  end

  # Indicates whether Peachy is being quiet, i.e. whether Peachy will return nil
  # when an XML node is not found by a Peachy::Proxy
  def self.being_quiet?
    return @quiet
  end

  # Tells Peachy that it should be whiny, and print all of the steps that it knows
  # to report to screen.
  def self.whine
    @whine = true
  end

  # Indicates whether Peachy will #whine when it runs or not.
  def self.whiny?
    return @whine
  end

  # Creates a new proxy from the XML string passed to it.
  def self.proxy xml
    create_factory unless defined? @factory
    return Proxy.new(@factory.make_from(xml))
  end

  private
  def self.create_factory
    @factory ||= Peachy::Parsers::ParserFactory.new
    @factory.load_parser
    return @factory
  end
end
