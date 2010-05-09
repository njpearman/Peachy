require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy'))

Spec::Runner.configure do |config|
  Peachy.whine
end
