module Peachy
  # Included in Peachy::MethodName.  All methods in this module expect an instance
  # variable named @method_name to be defined.
  module StringStyler
    private
    module Stripper
      # This is a bit rubbish.  Need to include the method somewhere other than
      # the private instance block in StringStyler.
      def strip_underscores_and_upcase string
        with_namespace(string).gsub(/_([a-z])/){|s| s.upcase}.delete('_')
      end
      
      def with_namespace string
        string.gsub(/NS/, ':')
      end
    end

    include Stripper

    def as_camel_case
      strip_underscores_and_upcase(@method_name)
    end

    def as_pascal_case
      namespaced = @method_name.split('NS')
      namespaced.map {|part| strip_underscores_and_upcase(part.capitalize)}.join (':')
    end

    def as_hyphen_separated
      with_namespace(@method_name).gsub(/_/, '-')
    end

    def as_underscore
      with_namespace(@method_name)
    end
  end
end
