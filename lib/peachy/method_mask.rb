module Peachy
  module MethodMask
    private
    def hide_public_methods exceptions
      methods_to_hide = public_instance_methods.clone
      exceptions.each do |to_stay_public|
        methods_to_hide.delete(to_stay_public)
      end
      private *methods_to_hide
    end
  end
end
