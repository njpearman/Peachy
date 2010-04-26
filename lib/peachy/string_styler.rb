module Peachy
  module StringStyler
    private
    def as_camel_case method_name
      method_name.capitalize.gsub(/_([a-z])/){|s| s.upcase}.delete('_')
    end

    def as_hyphen_separated method_name
      method_name.gsub(/_/, '-')
    end
  end
end
