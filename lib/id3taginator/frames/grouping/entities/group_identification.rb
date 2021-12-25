# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Grouping
      module Entities
        class GroupIdentification
          include Extensions::Comparable

          attr_accessor :owner_id, :group_symbol, :group_dependant_data

          # constructor
          #
          # @param owner_id [String] the owner id
          # @param group_symbol [Integer] the group symbol, number between 0 and 255
          # @param group_dependant_data [String] data bytes represented as a String (str.bytes)
          def initialize(owner_id, group_symbol, group_dependant_data)
            @owner_id = owner_id
            @group_symbol = group_symbol
            @group_dependant_data = group_dependant_data
          end
        end
      end
    end
  end
end
