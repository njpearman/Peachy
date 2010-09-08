module Peachy
  module MethodMask
    private
    def hide_public_methods exceptions
      methods_to_hide = public_instance_methods.map {|method| method unless exceptions.include? method }.compact
      private *methods_to_hide
    end
  end
end
