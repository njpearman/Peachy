module Peachy
  module MorphIntoArray
    def you_use_me_like_an_array method_name, *args
      method_name == :[] and args.one? and args.first == 0
    end

    def mimic object_to_mimic
      eval_on_singleton_class do
        # NetBeans complains about this syntax, but it's fine.
        define_method(:method_missing) do |method_name, *args, &block|
          puts "[Peachy::Proxy] #{node_name} can only do '#{method_name}' with '#{args}' if an Array can.  You see, really, #{node_name} is an array now." if Peachy.whiny?
          return object_to_mimic.send(method_name, *args, &block)
        end
      end
    end

    def morph_into_array to_add_to_array
      puts "[Peachy::Proxy] Currently acts as #{@acts_as}" if Peachy.whiny?
      raise AlreadyAnOnlyChild.new(node_name) if is_an_only_child
      puts "[Peachy::Proxy] So #{node_name} should be an Array, then." if Peachy.whiny?
      mimic [to_add_to_array]
      return to_add_to_array
    end

    def acts_as_only_child
      @acts_as = :only_child
    end

    def is_an_only_child
       @acts_as == :only_child
    end
  end
end
