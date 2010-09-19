if RUBY_VERSION < "1.9"
  def version_safe_method_id(method_name)
    method_name.to_s
  end
else
  def version_safe_method_id(method_name)
    method_name.to_sym
  end
end