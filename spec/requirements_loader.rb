class RequirementsLoader
  class << self
    def require_all_from directory_name, &block
      Dir.foreach(File.expand_path(directory_name)) do |file|
        next if file =~ HereOrBack
        absolute_path = File.join(directory_name, file)
        if File.directory?(absolute_path)
          require_all_from absolute_path, &block
        else
          act_on_file absolute_path, &block
        end
      end
    end

    private
    def act_on_file file
      if block_given?
        yield file
      else
        require_if_ruby_file file
      end
    end

    def require_if_ruby_file file
      require file if file =~ /\.rb$/
    end
  end

  private
  HereOrBack = /^(?:\.{1,2})$/
end
