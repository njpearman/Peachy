module Peachy
  class MethodName
    def initialize method_name
      @method_name = method_name.to_s
    end

    def variations
      arr = [@method_name]
      Peachy::StringStyler.instance_methods.each{|method| arr << send(method, @method_name) }
      arr
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
