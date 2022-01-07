# frozen_string_literal: true

module Id3Taginator
  class Id3v2Tag
    include Frames::UfidFrames
    include Frames::TextFrames
    include Frames::UrlFrames
    include Frames::IplFrames
    include Frames::McdiFrames
    include Frames::LyricsFrames
    include Frames::CommentFrames
    include Frames::PictureFrames
    include Frames::GeoFrames
    include Frames::CountFrames
    include Frames::BufferFrames
    include Frames::ToSFrames
    include Frames::EncryptionFrames
    include Frames::GroupingFrames
    include Frames::PrivateFrames
    include Frames::CustomFrames

    IDENTIFIER = 'ID3'

    attr_writer :options

    # checks if the given stream contains a id3v2 tag
    #
    # @param file [StringIO, IO, File] the file stream to check
    #
    # @return [Boolean] true if contains an id3v2 tag, else false
    def self.id3v2_tag?(file)
      tag = file.read(3)
      file.seek(0)

      tag == IDENTIFIER
    end

    # builds an id3tag from the given file stream and the passed options
    #
    # @param file [StringIO, IO, File] the file stream
    # @param options [Options::Options] options that should be used
    #
    # @return [Id3v2Tag] the id3v2tag object,the specific object is determined by the tag version
    def self.build_from_file(file, options)
      file.seek(0)
      tag = file.read(3)
      raise Errors::Id3TagError, "#{tag} is no valid id3v2 tag. Tag seems corrupted." unless tag == IDENTIFIER

      major_version = file.readbyte
      minor_version = file.readbyte
      flags = Header::Id3v2Flags.new(file.readbyte)
      tag_size = Util::MathUtil.to_32_synchsafe_integer(file.read(4).bytes)

      tag_data = file.read(tag_size)
      tag_data = Util::SyncUtil.undo_synchronization(StringIO.new(tag_data)) if flags.unsynchronized?

      id3v2_tag = id3v2_tag_for_version(major_version)
      # noinspection RubyArgCount
      id3v2_tag.new(minor_version, flags, tag_size, StringIO.new(tag_data), options)
    end

    # builds an empty id3tag for the given version
    #
    # @param version [Integer] the id3tag major version 2,3 or 4
    # @param options [Options::Options] the options to use
    #
    # @return [Id3v2Tag] the Id3v2 tag object for the requested version
    def self.build_for_version(version, options)
      case version
      when 2
        Id3v22Tag.build_empty(options)
      when 3
        Id3v23Tag.build_empty(options)
      when 4
        Id3v24Tag.build_empty(options)
      else
        raise Errors::Id3TagError, "Id3v2.#{version} is not supported."
      end
    end

    # Constructor
    #
    # @param header_size [Integer] number of bytes for the Header, usually 6 for v2 and 10 for v3 and v4
    # @param major_version [Integer] the major version, in v2.[major].[minor]
    # @param minor_version [Integer] the minor version, in v2.[major].[minor]
    # @param flags [Header::Id3v2Flags] the 2 Byte header flags wrapped in the entity
    # @param tag_size [Integer] number of bytes the excluding header/footer of the tag
    # @param frames [Array<Frames::Id3TagFrame>] array of frames of the id3tag
    # @param extended_header [Header::Id3v23ExtendedHeader, Header::Id3v24ExtendedHeader, nil] the extended header of
    #                                                                                        present or nil otherwise
    def initialize(header_size, major_version, minor_version, flags, tag_size, frames, extended_header)
      @header_size = header_size
      @major_version = major_version
      @minor_version = minor_version
      @flags = flags
      @tag_size = tag_size
      @extended_header = extended_header
      @frames = frames
    end

    # gets the version of this id3tag entity
    #
    # @return [String] returns the version in the form 2.x.y
    def version
      "2.#{@major_version}.#{@minor_version}"
    end

    # returns the number of bytes of the total tag, including header and footer
    #
    # @return [Integer] the total tag size in bytes
    def total_tag_size
      @header_size + @tag_size + (@flags&.footer? ? 10 : 0)
    end

    # selects all frames with the given frame id
    #
    # @return [Array<Frames::Id3v2Frame>] an array of Id3v2Frames such as CustomFrame, AlbumFrame etc.
    def frames(frame_id)
      @frames.select { |f| f.frame_id == frame_id }
    end

    # adds a new frame. There will be no validity checks, even invalid frames can be added, essentially rendering
    # the Id3 tag broken
    #
    # @param frame [Frames::Id3v2Frame] the frame to add
    def add_frame(frame)
      raise Errors::Id3TagError, 'The given frame is no Id3v2Frame.' unless frame.is_a?(Frames::Id3v2Frame)

      @frames << frame
    end

    # returns the number of frames for this tag
    #
    # @return [Integer] number of frames
    def number_of_frames
      @frames.length
    end

    # determined if the tag is unsynchronized
    #
    # @return [Boolean] true if unsynchronized, else false
    def unsynchronized?
      @flags.unsynchronized?
    end

    # sets the tag synchronized or unsynchronized. Should be false, only required for very old player
    #
    # @param enabled [Boolean] sets unsynchronized enabled or disabled
    def unsynchronized=(enabled = true)
      @flags.unsynchronized = enabled
    end

    def add_size_tag_if_not_present(audio_size)
      return nil unless @options.add_size_frame

      return nil if @major_version == 4 && !@options.ignore_v24_frame_error

      size_frame = size
      return nil unless size_frame.nil?

      self.size = audio_size
    end

    # dumps the tag to a byte string. This dump already takes unsynchronization, padding and all other options
    # into effect
    #
    # @return [String] tag dump as a String. tag.bytes represents the byte array
    def to_bytes
      # add up frame size and unsyc if necessary
      frames_payload = ''
      @frames.each do |frame|
        frames_payload += frame.to_bytes
      end

      frames_payload += "\x00" * @options.padding_bytes if @options.padding_bytes.positive?
      frames_payload = Util::SyncUtil.add_synchronization(frames_payload) if unsynchronized?
      frame_size = frames_payload.size

      res = 'ID3'
      res += @major_version.chr
      res += @minor_version.chr
      res += @flags.to_bytes
      res += Util::MathUtil.from_32_synchsafe_integer(frame_size)
      res += frames_payload

      if @flags&.footer?
        res = '3DI'
        res += @major_version.chr
        res += @minor_version.chr
        res += @flags.to_bytes
        res += Util::MathUtil.from_32_synchsafe_integer(frame_size)
      end

      res
    end

    # creates an id3v2 tag for the specific version
    #
    # @param major_version [Integer] the major version, 2,3 or 4
    #
    # @return [Class<Id3v2Tag>] the correct id3v2 tag object
    def self.id3v2_tag_for_version(major_version)
      case major_version
      when 2
        Id3v22Tag
      when 3
        Id3v23Tag
      when 4
        Id3v24Tag
      else
        raise Errors::Id3TagError, "Unsupported version: 2.#{major_version}"
      end
    end

    # parses the frames for the given id3v2 tag version
    #
    # @param file [StringIO, IO, File] the file or StringIO stream the bytes can be fetched from
    # @param version [Integer]
    #
    # @return [Array<Frames::Id3v2Frame>] list of all parsed frames
    def parse_frames(file, version = 3)
      generator = Frames::Id3v2FrameFactory.new(file, version, @options)

      result = []
      frame = generator.next_frame
      until frame.nil?
        result << frame
        frame = generator.next_frame
      end

      result
    end

    private_class_method :id3v2_tag_for_version
  end
end
