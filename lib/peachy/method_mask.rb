module Peachy
  module MethodMask
    include Compatibility

    private
    def hide_public_methods exceptions
      formatted_exception = exceptions.map {|method_name| version_safe_method_id(method_name)}
      methods_to_hide = public_instance_methods.map {|method| method unless formatted_exception.include? method }.compact
      private *methods_to_hide
    end
  end
end
