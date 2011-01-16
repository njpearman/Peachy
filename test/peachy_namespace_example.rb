#!/usr/bin/ruby

require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy'))

proxy = Peachy::Proxy.new '<testnode>Check meh.</testnode>'
puts proxy.testnode.value


xml = <<XML
<root status="ok">
  <tags:toptags>
    <tag position="1">
      <tag:name>rock</name>
    </tag>
    <tag position="2">
      <tag:name>electro</name>
    </tag>
    <tag position="3">
      <tag:name>alternative</name>
    </tag>
    <tag position="4">
      <tag:name>indie</name>
    </tag>
    <tag position="5">
      <tag:name>electronic</name>
    </tag>
    <tag position="6">
      <tag:name>pop</name>
    </tag>
    <tag position="7">
      <tag:name>metal</name>
    </tag>
  </toptags>
</root>
XML

proxy = Peachy::Proxy.new xml

puts "Status okay? #{proxy.root.status == 'ok'}"
proxy.root.toptags.tag.each {|tag| puts "Found tag '#{tag.name.value}' at #{tag.position}" }
