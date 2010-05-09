module Peachy
  module MorphIntoArray
    def you_use_me_like_an_array method_name, *args
      method_name == :[] and args.one? and args.first == 0
    end

    def mimic object_to_mimic
      eval_on_singleton_class do
        define_method(:method_missing) do |method_name, *args|
          puts "[Peachy::Proxy] I can only do '#{method_name}' with '#{args}' if an Array can.  You see, really, I'm an array now."
          return object_to_mimic.send(method_name, *args) &block if block_given?
          return object_to_mimic.send(method_name, *args)
        end
      end
    end

    def morph_into_array
        raise AlreadyASingleChild.new(nokogiri_node.name) if @acts_as == :single_child
        puts "[Peachy::Proxy] So I should be an Array, then."
        real_proxy = Peachy::Proxy.new nokogiri_node
        mimic [real_proxy]
        return real_proxy
    end
  end
end
