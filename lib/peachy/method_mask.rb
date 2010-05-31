module Peachy
  module MethodMask
    private
    def hide_public_methods exceptions
      methods_to_hide = public_instance_methods.clone
      exceptions.each {|stay_public| methods_to_hide.delete(stay_public) }
      private *methods_to_hide
    end
  end
end
