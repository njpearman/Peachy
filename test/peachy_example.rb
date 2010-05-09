require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy'))

proxy = Peachy::Proxy.new '<testnode>Check meh.</testnode>'
puts proxy.testnode.value


xml = <<XML
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
XML

proxy = Peachy::Proxy.new xml

puts "Status okay? #{proxy.root.status == 'ok'}"
proxy.root.toptags.tag.each {|tag| puts "Found tag '#{tag.name.value}' at #{tag.position}" }
