module Peachy
  module ConventionChecks
    private
    # Checks whether the provided method name is in the accepted convention,
    # raising a MethodNotInRubyConvention if it's not.
    def check_for_convention method_name
      raise MethodNotInRubyConvention.new(method_name) unless method_name.matches_convention?
    end
  end
end
