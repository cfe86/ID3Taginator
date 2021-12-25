# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Ufid
      module Entities
        class UfidInfo
          include Extensions::Comparable

          attr_accessor :owner_id, :identifier

          # constructor
          #
          # @param owner_id [String] the owner id
          # @param identifier [String] the identifier bytes represented as a String (str.bytes)
          def initialize(owner_id, identifier)
            @owner_id = owner_id
            @identifier = identifier
          end
        end
      end
    end
  end
end
