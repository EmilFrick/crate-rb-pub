module ArrayHelpers 
    def self.split_into_five_arrays(original_array)
      original_array
      arrays = Array.new(10) { [] }

      original_array.each_with_index do |element, index|
        arrays[index % 10] << element
      end

      arrays.reject { |arr| arr.empty? }
  end
end