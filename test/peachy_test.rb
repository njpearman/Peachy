# A simple test script for running an example of using Peachy.
require 'ruby-debug'
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/invalid_proxy_parameters'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/method_not_in_ruby_convention'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/no_matching_xml_part'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/convention_checks'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/string_styler'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/proxy'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/childless_proxy_with_attributes'))

proxy = Peachy::Proxy.new :xml => '<testnode>Check meh.</testnode>'
puts proxy.testnode