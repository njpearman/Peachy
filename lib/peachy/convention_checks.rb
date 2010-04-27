module Peachy
  module ConventionChecks
    private
    def check_for_convention method_name
      raise MethodNotInRubyConvention.new(method_name) unless matches_convention(method_name)
    end

    def matches_convention method_name
      method_name =~ /^[a-z]+(?:_[a-z]+){0,}$/
    end
  end
end
