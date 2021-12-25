# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Buffer
      class RecommendedBufferSizeFrame < Id3v2Frame
        include HasId

        frame_info :BUF, :RBUF, :RBUF

        attr_accessor :buffer_size, :embedded_info_flag, :offset_next_tag

        # builds the recommended buffer size frame
        #
        # @param buffer_size [Integer] the buffer size
        # @param embedded_info_flag [Boolean] true if infos are embedded
        # @param offset_next_tag [Integer] offset till next tag starts in bytes
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(buffer_size, embedded_info_flag, offset_next_tag, options = nil, id3_version: 3)
          supported?('RBUF', id3_version, options)

          argument_not_nil(buffer_size, 'buffer_size')
          argument_not_nil(embedded_info_flag, 'embedded_into_flag')
          argument_boolean(embedded_info_flag, 'embedded_into_flag')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.buffer_size = buffer_size
          frame.embedded_info_flag = embedded_info_flag
          frame.offset_next_tag = offset_next_tag
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          # noinspection RubyNilAnalysis
          @buffer_size = Util::MathUtil.to_number(stream.read(3).bytes)
          @embedded_info_flag = (stream.readbyte & 0b00000001) == 0b00000001
          offset_nxt_tag = stream.read(4)
          @offset_next_tag = offset_nxt_tag.nil? ? nil : offset_nxt_tag.bytes.pack('C*').unpack1('N')
        end

        def content_to_bytes
          buffer_size = @buffer_size.to_s(16).rjust(6, '0').scan(/../).map { |x| x.hex.chr }.join
          embedded_into = @embedded_info_flag ? "\x01" : "\x00"
          offset_next_tag = if @offset_next_tag.nil?
                              nil
                            else
                              @offset_next_tag.to_s(16).rjust(8, '0').scan(/../).map { |x| x.hex.chr }.join
                            end

          offset_next_tag.nil? ? merge(buffer_size, embedded_into) : merge(buffer_size, embedded_into, offset_next_tag)
        end
      end
    end
  end
end
