# A simple test script for running an example of using Peachy.
require 'ruby-debug'
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/invalid_proxy_parameters'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/method_not_in_ruby_convention'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/no_matching_xml_part'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/convention_checks'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/string_styler'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/method_name'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/proxy'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/childless_proxy_with_attributes'))

proxy = Peachy::Proxy.new :xml => '<testnode>Check meh.</testnode>'
puts proxy.testnode


xml = <<STR
<root status="ok">
  <toptags>
    <tag position="1">
      <name>rock</name>
    </tag>
    <tag position="2">
      <name>electro</name>
    </tag>
    <tag position="3">
      <name>alternative</name>
    </tag>
    <tag position="4">
      <name>indie</name>
    </tag>
    <tag position="5">
      <name>electronic</name>
    </tag>
    <tag position="6">
      <name>pop</name>
    </tag>
    <tag position="7">
      <name>metal</name>
    </tag>
  </toptags>
</root>
STR

proxy = Peachy::Proxy.new :xml => xml

puts "Status okay? #{proxy.root.status == 'ok'}"
proxy.root.toptags.tag.each {|tag| puts "Found tag '#{tag.name}' at #{tag.position}" }
