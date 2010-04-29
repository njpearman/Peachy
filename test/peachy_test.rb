require 'requires'

proxy = Peachy::Proxy.new :xml => '<testnode>Check meh.</testnode>'
puts proxy.testnode


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

proxy = Peachy::Proxy.new :xml => xml

puts "Status okay? #{proxy.root.status == 'ok'}"
proxy.root.toptags.tag.each {|tag| puts "Found tag '#{tag.name}' at #{tag.position}" }
