require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'peachy'))
require 'mocha'

RSpec.configure do |config|
  config.mock_with :mocha
end
