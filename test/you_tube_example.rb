#!/usr/bin/ruby
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy'))

xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" 
      xmlns:media="http://search.yahoo.com/mrss/" 
      xmlns:openSearch="http://a9.com/-/spec/opensearchrss/1.0/" 
      xmlns:gd="http://schemas.google.com/g/2005" 
      xmlns:gml="http://www.opengis.net/gml" 
      xmlns:yt="http://gdata.youtube.com/schemas/2007" 
      xmlns:georss="http://www.georss.org/georss">
  <id>http://gdata.youtube.com/feeds/api/videos</id>
  <title type="text">YouTube Videos matching query: bat for lashes interview</title>
  <link rel="alternate" type="text/html" href="http://www.youtube.com"/>
  <author>
    <name>YouTube</name>
    <uri>http://www.youtube.com/</uri>
  </author>
  <openSearch:startIndex>1</openSearch:startIndex>
  <openSearch:itemsPerPage>5</openSearch:itemsPerPage>
  <entry>
    <id>http://gdata.youtube.com/feeds/api/videos/Ri6Mwq_K56s</id>
    <category scheme="http://schemas.google.com/g/2005#kind" term="http://gdata.youtube.com/schemas/2007#video"/>
    <title type="text">Videa title.</title>
    <link rel="http://gdata.youtube.com/schemas/2007#video.responses" type="application/atom+xml" href="http://gdata.youtube.com/feeds/api/videos/Ri6Mwq_K56s/responses"/>
    <link rel="http://gdata.youtube.com/schemas/2007#video.related" type="application/atom+xml" href="http://gdata.youtube.com/feeds/api/videos/Ri6Mwq_K56s/related"/>
    <author>
      <name>BillboardMagazine</name>
      <uri>http://gdata.youtube.com/feeds/api/users/billboardmagazine</uri>
    </author>
    <media:group>
      <media:category label="Music" scheme="http://gdata.youtube.com/schemas/2007/categories.cat">Music</media:category>
      <media:content url="http://www.youtube.com/v/Ri6Mwq_K56s?f=videos&amp;app=youtube_gdata" type="application/x-shockwave-flash" medium="video" isDefault="true" expression="full" duration="187" yt:format="5"/>
      <media:keywords>Alternative, Indie, Bat For Lashes, Natasha Khan, Lollapalooza</media:keywords>
      <media:player url="http://www.youtube.com/watch?v=Ri6Mwq_K56s&amp;feature=youtube_gdata_player"/>
      <media:title type="plain">Lollapalooza Video: Bat For Lashes Interview</media:title>
      <yt:duration seconds="187"/>
    </media:group>
    <gd:rating average="4.9428573" max="5" min="1" numRaters="70" rel="http://schemas.google.com/g/2005#overall"/>
    <yt:statistics favoriteCount="101" viewCount="18935"/>
  </entry>
</feed>
XML

proxy = Peachy::Proxy.new xml

puts "Feed ID: #{proxy.feed.id.value}"
puts "Entry content available at: #{proxy.feed.entry.group.content.url}"
