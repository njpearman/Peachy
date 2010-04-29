class MethodNotInRubyConvention < Exception
  def initialize method_name
    super(MessageTemplate.gsub /method_name/, method_name.to_s)
  end

  private
  
  MessageTemplate = <<EOF
You've tried to infer method_name using Peachy, but Peachy doesn't currently like defining methods that break Ruby convention.
Please use methods matching ^[a-z]+(?:_[a-z]+)?{0,}$ and Peachy will try to do the rest with your XML.*/
EOF
end
