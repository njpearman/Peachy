module Peachy
  module MorphIntoArray
    private
    def you_use_me_like_an_array method_name, block_given, *args
      return ((block_given or args.size > 0) and array_can?(method_name))
    end

    def array_can? method_name
      Array.instance_methods.include?(method_name.to_s)
    end

    def mimic object_to_mimic
      eval_on_singleton_class do
        define_method(:mimic) { object_to_mimic }
        include Mimic
      end
    end

    def morph_into_array to_add_to_array, method_to_invoke, *args, &block
      puts "[Peachy::Proxy] Currently acts as #{@acts_as}" if Peachy.whiny?
      raise AlreadyAnOnlyChild.new(node_name) if is_an_only_child
      puts "[Peachy::Proxy] So #{node_name} should be an Array, then." if Peachy.whiny?
      mimic [to_add_to_array]
      return send(method_to_invoke, *args, &block)
    end

    def acts_as_only_child
      @acts_as = :only_child
    end

    def is_an_only_child
       @acts_as == :only_child
    end
  end
end
