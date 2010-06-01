module Peachy
  module Mimic
    def mimic
      raise NothingToMimic.new
    end

    # Delegates the method_missing call to the underlying object that is being
    # mimicked.
    def method_missing method_name, *args, &block
      mimic.send(method_name, *args, &block)
    end
  end
end
