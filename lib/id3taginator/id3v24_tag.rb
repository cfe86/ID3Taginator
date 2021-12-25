# frozen_string_literal: true

module Id3Taginator
  class Id3v24Tag < Id3v2Tag

    HEADER_SIZE = 10

    # builds an empty Id3v2.4 tag with the given options set
    #
    # @param options [Options::Options] the options to use
    #
    # @return [Id3v24Tag] returns an empty Id3v2.4 tag
    def self.build_empty(options)
      new(0, Header::Id3v2Flags.new(0x00), 0, nil, options)
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

      frames = tag_size.positive? ? parse_frames(tag_data_stream, 4) : []
      super(HEADER_SIZE, 4, minor_version, flags, tag_size, frames, ext_header)
    end

    # parses the extended header if present
    #
    # @param file [StringIO, IO, File] the file stream
    #
    # @return [Header::Id3v24ExtendedHeader] the extended header
    def parse_extended_header(file)
      size = Util::MathUtil.to_32_synchsafe_integer(file.read(4)&.bytes)
      number_of_flags = file.readbyte
      flags = file.read(number_of_flags)

      Header::Id3v24ExtendedHeader.new(size, flags)
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

    # determines if a footer is present
    #
    # @return [Boolean] true if a footer is present, else false
    def footer?
      @flags.footer?
    end

    # enables or disables a footer
    #
    # @param enabled [Boolean] true, if the footer should be set to the tag, else false
    def footer=(enabled = true)
      @flags.footer = enabled
    end
  end
end
