module Peachy
  module MethodMask
    private
    def hide_public_methods exceptions
      formatted_exception = exceptions.map {|method_name| version_safe_method(method_name)}
      methods_to_hide = public_instance_methods.map {|method| method unless formatted_exception.include? method }.compact
      private *methods_to_hide
    end

    def version_safe_method(method_name)
      /^1\.8/ === RUBY_VERSION ? method_name.to_s : method_name.to_s.to_sym
    end
  end
end
