module Peachy
  # MyMetaClass is a convenience Module for meta programming within a Class.
  module MyMetaClass
    def eval_on_singleton_class &block
      (class << self; self; end).class_eval &block
    end
  end
end
