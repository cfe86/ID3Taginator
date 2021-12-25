# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Encryption
      module Entities
        class EncryptionMethod
          include Extensions::Comparable

          attr_accessor :owner_id, :method_symbol, :encryption_data

          # constructor
          #
          # @param owner_id [String] the owner id
          # @param method_symbol [Integer] method symbol between 0 and 255
          # @param encryption_data [String] encryption data represented as a String
          def initialize(owner_id, method_symbol, encryption_data)
            @owner_id = owner_id
            @method_symbol = method_symbol
            @encryption_data = encryption_data
          end
        end
      end
    end
  end
end
