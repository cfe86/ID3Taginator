# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Ipl
      class InvolvedPeopleFrame < Id3v2Frame
        include HasId

        frame_info :IPL, :IPLS, :IPLS

        attr_accessor :involved_people

        # builds the group identification frame
        #
        # @param involved_people [Array<Entities::InvolvedPerson>, Entities::InvolvedPerson] the involved people
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(involved_people, options = nil, id3_version: 3)
          supported?('IPLS', id3_version, options)

          argument_not_empty(involved_people, 'involved_people')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.involved_people = involved_people.is_a?(Array) ? involved_people : [involved_people]
          frame
        end

        def process_content(content)
          content = decode_using_encoding_byte(content).split("\x00")
          @involved_people = []
          until content.empty?
            involvement = content.shift
            involvee = content.shift
            person = Entities::InvolvedPerson.new(involvement, involvee)
            @involved_people << person
          end
        end

        def content_to_bytes
          content = @involved_people.map { |person| "#{person.involvement}\x00#{person.involvee}" }.join("\x00")
          encode_and_add_encoding_byte(content)
        end
      end
    end
  end
end
