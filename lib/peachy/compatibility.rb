module Peachy
  module Compatibility
    def version_safe_method_id(method)
      RUBY_VERSION < '1.9' ? method.to_s : method.to_sym
    end
  end
end
