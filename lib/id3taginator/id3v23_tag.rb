# frozen_string_literal: true

module Id3Taginator
  class Id3v23Tag < Id3v2Tag

    HEADER_SIZE = 10

    # builds an empty Id3v232 tag with the given options set
    #
    # @param options [Options::Options] the options to use
    #
    # @return [Id3v23Tag] returns an empty Id3v2.3 tag
    def self.build_empty(options)
      new(0, Header::Id3v2Flags.new(0x00), 0, StringIO.new, options)
    end

    # Constructor
    #
    # @param minor_version [Integer] the minor version, in v2.[major].[minor]
    # @param flags [Header::Id3v2Flags] the 2 Byte header flags wrapped in the entity
    # @param tag_size [Integer] number of bytes the excluding header/footer of the tag
    # @param tag_data_stream [StringIO, IO, File] the file stream
    # @param options [Options::Options] the options to use
    def initialize(minor_version, flags, tag_size, tag_data_stream, options)
      @options = options
      ext_header = flags.extended_header? && tag_size.positive? ? parse_extended_header(tag_data_stream) : nil
      frames = tag_size.positive? ? parse_frames(tag_data_stream, 3) : []
      super(HEADER_SIZE, 3, minor_version, flags, tag_size, frames, ext_header)
    end

    # parses the extended header if present
    #
    # @param file [StringIO, IO, File] the file stream
    #
    # @return [Header::Id3v23ExtendedHeader] the extended header
    def parse_extended_header(file)
      size = Util::MathUtil.to_number(file.read(4)&.bytes)
      flags = file.read(2)

      raise Errors::Id3TagError, 'Could not find extended header flag bytes. ID3v2 Tag is corrupt.' if flags.nil?

      padding = Util::MathUtil.to_number(file.read(4)&.bytes)

      ext_header = Header::Id3v23ExtendedHeader.new(size, flags, padding)
      ext_header.crc_data = file.read(4) if ext_header.crc?
      ext_header
    end

    # determines if an extended header is present
    #
    # @return [Boolean] true if header is present, else false
    def extended_header?
      @flags.extended_header?
    end

    # determines if experimental tags are present
    #
    # @return [Boolean] true if experimental tags present, else false
    def experimental?
      @flags.experimental?
    end
  end
end
