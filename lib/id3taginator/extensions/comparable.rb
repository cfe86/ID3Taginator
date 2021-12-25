# frozen_string_literal: true

module Id3Taginator
  module Extensions
    # offers compare methods
    module Comparable
      # compares the instance variables of 2 objects for equality
      # @param obj1 object 1
      # @param obj2 object 2
      # @return [Boolean] true if both instance variables are the same, else false
      def compare(obj1, obj2)
        is_same = true
        obj1.instance_variables.each do |it|
          is_same = false if obj1.instance_variable_get(it) != obj2.instance_variable_get(it)
        end

        is_same
      end

      # compares all Comparables using the defined compare method
      # @param other [Object] the object to compare with
      # @return [Boolean] true if equal, else false
      def ==(other)
        compare(self, other)
      end
    end
  end
end
