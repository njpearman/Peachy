# -*- encoding: utf-8 -*-
require 'lib/peachy/version'

Gem::Specification.new do |s|
  s.name = "peachy"
  s.version = Peachy::VERSION

  s.authors = ["NJ Pearman"]
  s.email = ["n.pearman@gmail.com"]
  s.description = <<DESCRIPTION
Peachy is an XML slurper that sits on top of existing XML parsers.  It dynamically
creates object-trees for simple integration of XML data sources.
DESCRIPTION

  s.files = Dir.glob("{lib,spec}/**/*") + %w(README.rdoc History.txt)
  s.extra_rdoc_files = ["README.rdoc"]

  s.homepage = "http://github.com/njpearman/peachy"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.rubygems_version = "1.3.6"
  s.summary = <<SUMMARY
Peachy gives a very simple object-style interface on top of an XML DOM.
SUMMARY
end

