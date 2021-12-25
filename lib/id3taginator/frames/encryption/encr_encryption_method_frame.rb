# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Encryption
      class EncryptionMethodFrame < Id3v2Frame
        include HasId

        frame_info nil, :ENCR, :ENCR

        attr_accessor :owner_id, :method_symbol, :encryption_data

        # builds the encryption method frame
        #
        # @param owner_id [String] the owner id
        # @param method_symbol [Integer] method symbol between 0 and 255
        # @param encryption_data [String] encryption data bytes represented as a String (str.bytes)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(owner_id, method_symbol, encryption_data, options = nil, id3_version: 3)
          supported?('ENCR', id3_version, options)

          argument_not_nil(owner_id, 'owner_id')
          argument_between_num(method_symbol, 'method_symbol', 0, 255)
          argument_not_nil(encryption_data, 'encryption_data')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.owner_id = owner_id
          frame.method_symbol = method_symbol
          frame.encryption_data = encryption_data
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          @owner_id = read_stream_until(stream, ZERO)
          @method_symbol = stream.readbyte
          @encryption_data = stream.read
        end

        def content_to_bytes
          merge(@owner_id, "\x00", @method_symbol.chr, @encryption_data)
        end
      end
    end
  end
end
