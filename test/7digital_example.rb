#!/usr/bin/ruby
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy'))

xml = <<SEVENDIG
<?xml version="1.0" encoding="UTF-8"?>
<response status="ok"
          version="1.2"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
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
SEVENDIG

proxy = Peachy::Proxy.new xml

puts "Response details:  status=#{proxy.response.status} version=#{proxy.response.version}"
proxy.response.tags.tag.each do |tag|
  puts "Found tag '#{tag.text.value}' with count #{tag.count.value}"
end
