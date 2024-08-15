module Helpers
    def self.direct_methods(klass)
    # Get all methods including inherited
    all_methods = klass.instance_methods
    # Get methods from ancestors excluding the current class
    inherited_methods = klass.ancestors[1..-1].flat_map(&:instance_methods).uniq
    # Subtract inherited methods from all methods
    all_methods - inherited_methods
  end
end