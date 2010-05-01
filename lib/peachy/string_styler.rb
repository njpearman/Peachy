module Peachy
  module StringStyler
    def as_camel_case method_name
      method_name.gsub(/_([a-z])/){|s| s.upcase}.delete('_')
    end

    def as_hyphen_separated method_name
      method_name.gsub(/_/, '-')
    end

    def as_pascal_case method_name
      method_name.capitalize.gsub(/_([a-z])/){|s| s.upcase}.delete('_')
    end
  end
end
