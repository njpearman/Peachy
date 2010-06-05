module Peachy
  class CurrentMethodCall
      extend MethodMask
      include MyMetaClass, XmlNode

      def initialize proxy, method
        @method_name = method
        @proxy = proxy
      end

      def create_method_for_child_or_content matches
        return define_child_array(matches) if matches.size > 1
        child = matches[0].create_from_element
        define_child_as(child)
      end

      def create_attribute
        create_method_for_attribute if @proxy.node.has_children_and_attributes?
      end

      def create_method_for_attribute
        match = find_match_by_attributes
        yield match if block_given?
        define_child_as(match.content) unless match.nil?
      end

      [:find_matches, :find_match_by_attributes].each do |method|
        define_method(method) { @proxy.node.send(method, @method_name) }
      end

      def define_child_array matches
        define_child(@method_name) { return CurrentMethodCall.matches_to_array(matches) }
      end

      def define_child_as child
        define_child(method_name) { return child }
      end

      def define_child method_name, &block
        @proxy.eval_on_singleton_class { define_method(method_name.to_sym, &block) }
        yield
      end

      private
      attr_reader :method_name

      def self.matches_to_array matches
        matches.inject([]) {|array, child| array << child.create_from_element }
      end
  end
end
