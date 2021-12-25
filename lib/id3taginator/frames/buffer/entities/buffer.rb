# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Buffer
      module Entities
        class Buffer
          include Extensions::Comparable

          attr_accessor :buffer_size, :embedded_info_flag, :offset_next_tag

          # constructor
          #
          # @param buffer_size [Integer] the buffer size
          # @param embedded_info_flag [Boolean] true if infos are embedded
          # @param offset_next_tag [Integer, nil] offset till next tag starts in bytes
          def initialize(buffer_size, embedded_info_flag, offset_next_tag)
            @buffer_size = buffer_size
            @embedded_info_flag = embedded_info_flag
            @offset_next_tag = offset_next_tag
          end
        end
      end
    end
  end
end
