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
  end
end
