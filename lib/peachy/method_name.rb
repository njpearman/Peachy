module Peachy
  class MethodName
    include StringStyler

    def initialize method_name
      @method_name = method_name
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
  end
end
