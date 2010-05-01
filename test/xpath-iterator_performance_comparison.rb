#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'

xml = '<xml><first>Hello<</first><second>Hello</second><three>Hello</three></xml>'

def time_for_code xml
  start = Time.now
  (1..1000).each { Nokogiri::XML(xml).children.any? {|child| child.kind_of? Nokogiri::XML::Element} }
  puts "Time taken with code: #{Time.now - start}"
end

def time_for_xpath xml
  start = Time.now
  (1..1000).each{ Nokogiri::XML(xml).xpath('./*').size > 0 }
  puts "Time taken with xpath: #{Time.now - start}"
end

time_for_code xml
time_for_xpath xml
