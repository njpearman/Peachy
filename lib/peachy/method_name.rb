module Peachy
  class MethodName
    include StringStyler

    def initialize method_name
      @method_name = method_name.to_s
    end

    # Returns an array of distinct valid variations in the method name.
    # The valid varations are the underlying method name, plus all variations
    # provided by methods defined in the StringStyler module.
    def variations
      (variation_methods.inject([@method_name]) do |array, method|
        array << send(method)
      end).uniq
    end

    # Checks whether the method name is in the accepted convention, raising a
    # MethodNotInRubyConvention if it's not.  This check does not allow method
    # names to have question marks, exclamation marks or numbers, however.
    def check_for_convention
      raise MethodNotInRubyConvention.new(self) unless matches_convention?
    end

    def to_s
      return @method_name
    end

    def to_sym
      return @method_name.to_sym
    end

    private
    def variation_methods
      Peachy::StringStyler.private_instance_methods
    end

    # Checks whether the method name matches the Ruby convention of lowercase with
    # underscores.  This method does not allow question marks, excalmation marks
    # or numbers, however.
    def matches_convention?
      !(@method_name =~ /^[a-z]+(?:_[a-z]+){0,}$/).nil?
    end
  end
end
