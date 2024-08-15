class NotOveriddenError < StandardError
  def initialize(module_name, class_name, method_name)
    super(set_custom_message(module_name, class_name, method_name))      
  end
  
  private
  
  def set_custom_message(module_name, class_name, method_name)
    "#{class_name} uses the module #{module_name} and need to override the method #{method_name}"
  end
end