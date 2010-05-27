module Peachy
  module Mimic
    def method_missing method_name, *args, &block
      mimic.send(method_name, *args, &block)
    end
  end
end
