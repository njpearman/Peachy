module Peachy
  class MethodName
    def initialize method_name
      @method_name = method_name.to_s
    end

    def variations
      [@method_name, as_camel_case(@method_name), as_hyphen_separated(@method_name)]
    end

    def to_s
      return @method_name
    end

    def to_sym
      return @method_name.to_sym
    end

    private
    include StringStyler
  end
end
