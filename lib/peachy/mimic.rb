module Peachy
  module Mimic
    # Use this method to make a mimic of an object.  The first argument passed is
    # the object to be mimicked and the second is the subject of the mimic action.
    # All previous methods defined on the subject will be buried.
    def self.make_a_mimic_of to_mimic, subject
      subject.instance_eval do
        (class << self; self; end).class_eval do
          define_method(:subject) { to_mimic }
          include Mimic
        end
      end
    end

    # This method has been defined as a template.  If you just include Mimic, however,
    # you will get a NothingToMimic error when calling mimic.  Use Mimic#make_a_mimic_of
    # to turn an object into a mimic.
    def subject
      raise NothingToMimic.new
    end

    # Delegates the method_missing call to the underlying object that is being
    # mimicked.
    def method_missing method_name, *args, &block
      subject.send(method_name, *args, &block)
    end
  end
end
