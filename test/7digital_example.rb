require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy'))

xml = <<7DIG
<response status="ok"
          version="1.2"
          xsi:noNamespaceSchemaLocation="http://api.7digital.com/1.2/static/7digitalAPI.xsd">
  <tags>
    <page>1</page>
    <pageSize>10</pageSize>
    <totalItems>473</totalItems>
    <tag id="pop">
      <text>pop</text>
      <url>http://www.7digital.com/tags/pop?partner=1026</url>
      <count>131595</count>
    </tag>
    <tag id="electronic">
      <text>electronic</text>
      <url>http://www.7digital.com/tags/electronic?partner=1026</url>
      <count>94606</count>
    </tag>
    <tag id="rock">
      <text>rock</text>
      <url>http://www.7digital.com/tags/rock?partner=1026</url>
      <count>82011</count>
    </tag>
  </tags>
</response>
7DIG

proxy = Peachy::Proxy.new xml

puts "Response details:  status=#{proxy.response.status} version=#{proxy.response.version}"
proxy.response.tags.tag.each do |tag|
  puts "Found tag '#{tag.text.value}' with count #{tag.count.value}"
end
