# frozen_string_literal: true

module Id3Taginator
  class Id3v22Tag < Id3v2Tag

    HEADER_SIZE = 10

    # builds an empty Id3v2.2 tag with the given options set
    #
    # @param options [Options::Options] the options to use
    #
    # @return [Id3v22Tag] returns an empty Id3v2.2 tag
    def self.build_empty(options)
      new(0, Header::Id3v2Flags.new(0x00), 0, StringIO.new, options)
    end

    # Constructor
    #
    # @param minor_version [Integer] the minor version, in v2.[major].[minor]
    # @param flags [Header::Id3v2Flags] the 2 Byte header flags wrapped in the entity
    # @param tag_size [Integer] number of bytes the excluding header/footer of the tag
    # @param tag_data_stream [StringIO|IO|File] the file stream
    # @param options [Options::Options] the options to use
    def initialize(minor_version, flags, tag_size, tag_data_stream, options)
      @options = options
      frames = tag_size.positive? ? parse_frames(tag_data_stream, 2) : []
      super(HEADER_SIZE, 2, minor_version, flags, tag_size, frames, nil)
    end
  end
end
