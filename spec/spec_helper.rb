require File.expand_path(File.join(File.dirname(__FILE__), '../lib/peachy'))
require 'mocha'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
