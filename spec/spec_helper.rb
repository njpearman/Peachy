require 'requirements_loader'

lib_directory = File.join(File.dirname(__FILE__), '../lib')
RequirementsLoader.require_all_from(lib_directory)

Spec::Runner.configure do |config|
  # these aren't the droids you're looking for....
end
