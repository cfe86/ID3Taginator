# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Private
      module Entities
        class PrivateFrame
          include Extensions::Comparable

          attr_accessor :owner_id, :private_data

          # constructor
          #
          # @param owner_id [String] the owner id
          # @param private_data [String] the private data bytes represented as a String (str.bytes)
          def initialize(owner_id, private_data)
            @owner_id = owner_id
            @private_data = private_data
          end
        end
      end
    end
  end
end
