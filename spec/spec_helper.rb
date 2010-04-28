require File.expand_path(File.join(File.dirname(__FILE__), '../lib/invalid_proxy_parameters'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/method_not_in_ruby_convention'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/no_matching_xml_part'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/convention_checks'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/string_styler'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/method_name'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/proxy'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy/childless_proxy_with_attributes'))

Spec::Runner.configure do |config|
  # these aren't the droids you're looking for....
end
