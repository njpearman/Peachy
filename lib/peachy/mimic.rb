module Peachy
  module Mimic
    def method_missing method_name, *args, &block
      @mimicked.send(method_name, *args, &block)
    end
  end
end
