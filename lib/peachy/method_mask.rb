module Peachy
  module MethodMask
    private
    def hide_public_methods exceptions
      exceptions.collect!{|method_name| version_safe_method(method_name)}
      methods_to_hide = public_instance_methods.map {|method| method unless exceptions.include? method }.compact
      private *methods_to_hide
    end

    def version_safe_method(method_name)
        if /^1\.8/ === RUBY_VERSION then
           method_name.to_s
        else
          method_name.to_s.to_sym
        end
   end

  end
end
