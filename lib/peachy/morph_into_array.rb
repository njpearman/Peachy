module Peachy
  module MorphIntoArray
    private
    def used_as_array method_name, block_given, *args
      return (block_given or args.size > 0) && array_can?(method_name)
    end

    def array_can? method_name
      (Array.instance_methods - Object.instance_methods).include?( version_safe_method_id(method_name))
    end

    def morph_into_array to_add_to_array, method_to_invoke, *args, &block
      puts "[Peachy::Proxy] Currently acts as #{@acts_as}" if Peachy.whiny?
      raise AlreadyAnOnlyChild.new(name) if is_an_only_child?
      puts "[Peachy::Proxy] So #{name} should be an Array, then." if Peachy.whiny?
      Mimic.make_a_mimic_of [to_add_to_array], self
      return send(method_to_invoke, *args, &block)
    end

    def acts_as_only_child
      @acts_as = :only_child
    end

    def is_an_only_child?
       @acts_as == :only_child
    end
  end
end
