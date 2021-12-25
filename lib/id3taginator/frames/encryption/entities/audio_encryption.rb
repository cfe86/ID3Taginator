# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Encryption
      module Entities
        class AudioEncryption
          include Extensions::Comparable

          attr_accessor :owner_id, :preview_start, :preview_length, :encryption_info

          # constructor
          #
          # @param owner_id [String] the owner id
          # @param preview_start [Integer] the start frame of the preview
          # @param preview_length [Integer] the preview length in frames
          # @param encryption_info [String] encryption info represented as a String
          def initialize(owner_id, preview_start, preview_length, encryption_info)
            @owner_id = owner_id
            @preview_start = preview_start
            @preview_length = preview_length
            @encryption_info = encryption_info
          end
        end
      end
    end
  end
end
