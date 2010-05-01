module Peachy
  # Included in Peachy::MethodName.  All methods in this module expect an instance
  # variable named @method_name to be defined.
  module StringStyler
    private
    module Stripper
      # This is a bit rubbish.  Need to include the method somewhere other than
      # the private instance block in StringStyler.
      def strip_underscores_and_upcase string
        string.gsub(/_([a-z])/){|s| s.upcase}.delete('_')
      end
    end

    include Stripper

    def as_camel_case
      strip_underscores_and_upcase(@method_name)
    end

    def as_pascal_case
      strip_underscores_and_upcase(@method_name.capitalize)
    end

    def as_hyphen_separated
      @method_name.gsub(/_/, '-')
    end
  end
end
