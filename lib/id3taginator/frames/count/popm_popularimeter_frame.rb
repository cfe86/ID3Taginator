# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Count
      class PopularityFrame < Id3v2Frame
        include HasId

        frame_info :POP, :POPM, :POPM

        attr_accessor :email, :rating, :counter

        # builds the popularimeter frame
        #
        # @param email [String] email of the user
        # @param rating [Integer] the rating between 0 and 255
        # @param counter [Integer] the counter, default 32 bit integer, but can be higher too
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(email, rating, counter, options = nil, id3_version: 3)
          supported?('POPM', id3_version, options)

          argument_not_nil(email, 'email')
          argument_not_nil(counter, 'counter')

          rating ||= 0
          argument_between_num(rating, 'rating', 0, 255)

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.email = email
          frame.rating = rating
          frame.counter = counter
          frame
        end

        def process_content(content)
          stream = StringIO.new(content)
          @email = read_stream_until(stream, ZERO)
          @rating = stream.readbyte
          @counter = Util::MathUtil.to_number(stream.read&.bytes)
        end

        def content_to_bytes
          counter = Util::MathUtil.from_number(@counter, 8, '0')
          merge(@email, "\x00", @rating.chr, counter)
        end
      end
    end
  end
end
