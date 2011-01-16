module Peachy
  class MethodName
    include StringStyler

    [:to_s, :to_sym].each {|method| define_method(method) { @method_name.send(method) }}
    
    def initialize method_name
      @method_name = method_name.to_s
    end

    # Returns an array of distinct valid variations in the method name.
    # The valid varations are the underlying method name, plus all variations
    # provided by methods defined in the StringStyler module.
    def variations
      variation_methods.inject([]) {|array, method| array << send(method)}.uniq
    end

    def as_xpath 
      variations.map {|variation| "./#{variation}" } * '|'
    end

    # Checks whether the method name is in the accepted convention, raising a
    # MethodNotInRubyConvention if it's not.  This check does not allow method
    # names to have question marks, exclamation marks or numbers, however.
    def check_for_convention
      raise MethodNotInRubyConvention.new(self) unless matches_convention?
    end

    private
    def variation_methods
      Peachy::StringStyler.private_instance_methods
    end

    # Checks whether the method name matches the Ruby convention of lowercase with
    # underscores.  The only exception is using NS to indicate the end of an XML namespace.
    # Note that this method does not allow question marks, exclamation marks or numbers.
    def matches_convention?
      @method_name =~ /^[a-z]+(?:_[a-z]+){0,}(?:NS[a-z]+(?:_[a-z]+){0,})?$/
    end
  end
end
