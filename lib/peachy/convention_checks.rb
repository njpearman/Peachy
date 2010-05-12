module Peachy
  module ConventionChecks
    private
    # Checks whether the provided method name is in the accepted convention,
    # raising a MethodNotInRubyConvention if it's not.
    def check_for_convention method_name
      raise MethodNotInRubyConvention.new(method_name) unless matches_convention(method_name)
    end

    # Checks whether the given method name matches the Ruby convention of
    # lowercase with underscores.  This method does not allow question marks,
    # excalmation marks or numbers, however.
    def matches_convention method_name
      method_name.to_s =~ /^[a-z]+(?:_[a-z]+){0,}$/
    end
  end
end
