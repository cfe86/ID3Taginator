# frozen_string_literal: true

module Id3Taginator
  class AudioFile
    include Extensions::Optionable

    attr_reader :id3v1_tag, :id3v2_tag

    # constructor
    #
    # @param file [StringIO, IO, File] the file stream
    # @param options [Options::Options] the options to use for this file
    # @param no_tag_parsing [Boolean] if true, no tag parsing is done (only use this for testing purposes, otherwise it
    #                                 renders the file literally useless)
    def initialize(file, options = Options::Options.new, no_tag_parsing: false)
      @file = file
      @options = options

      parse_id3v2_tag unless no_tag_parsing
      parse_id3v1_tag unless no_tag_parsing
      read_audio_data unless no_tag_parsing
    end

    # parses the id3v1 tag
    def parse_id3v1_tag
      length = @file.is_a?(File) ? @file.size : @file.length
      if length > 128
        @file.seek(-128, IO::SEEK_END)
        @id3v1_tag = Id3v1Tag.build_from_file(@file) if Id3v1Tag.id3v1_tag?(@file)
      end

      @audio_end_index = @id3v1_tag.nil? ? @file.size : @file.size - Id3v1Tag::TAG_SIZE
    end

    # parses the id3v2 tag
    def parse_id3v2_tag
      @id3v2_tag = Id3v2Tag.build_from_file(@file, @options) if Id3v2Tag.id3v2_tag?(@file)
      @audio_start_index = @id3v2_tag.nil? ? 0 : @id3v2_tag.total_tag_size

      @id3v2_tag&.add_size_tag_if_not_present(audio_size_without_id3v2_tag)
    end

    # removes the id3v1 tag
    def remove_id3v1_tag
      @id3v1_tag = nil
    end

    # creates the id3v1 tag. If a tag already exists, it must be removed first.
    #
    # @return [Id3v1Tag] the created Id3v1 tag
    def create_id3v1_tag
      raise Errors::Id3TagError, 'An ID3v1 tag already exists. Can\'t create a 2nd one.' unless @id3v1_tag.nil?

      @id3v1_tag = Id3v1Tag.new
      @id3v1_tag
    end

    # removes the id3v1 tag
    def remove_id3v2_tag
      @id3v2_tag = nil
    end

    # creates the id3v2.2 tag. If a tag already exists, it must be removed first.
    #
    # @return [Id3v22Tag, Id3v23Tag, Id3v24Tag] the created Id3v2.2 tag
    def create_id3v2_2_tag
      raise Errors::Id3TagError, 'An ID3v2.2 tag already exists. Can\'t create a 2nd one.' unless @id3v1_tag.nil?

      @id3v2_tag = Id3v2Tag.build_for_version(2, @options)
      @id3v2_tag
    end

    # creates the id3v2.3 tag. If a tag already exists, it must be removed first.
    #
    # @return [Id3v22Tag, Id3v23Tag, Id3v24Tag] the created Id3v2.3 tag
    def create_id3v2_3_tag
      raise Errors::Id3TagError, 'An ID3v2.3 tag already exists. Can\'t create a 2nd one.' unless @id3v1_tag.nil?

      @id3v2_tag = Id3v2Tag.build_for_version(3, @options)
      @id3v2_tag
    end

    # creates the id3v2.4 tag. If a tag already exists, it must be removed first.
    #
    # @return [Id3v22Tag, Id3v23Tag, Id3v24Tag] the created Id3v2.4 tag
    def create_id3v2_4_tag
      raise Errors::Id3TagError, 'An ID3v2.4 tag already exists. Can\'t create a 2nd one.' unless @id3v1_tag.nil?

      @id3v2_tag = Id3v2Tag.build_for_version(4, @options)
      @id3v2_tag
    end

    # writes the audio file to the specified path
    # Note: This path can be the same path as the path that was used to read the file
    #
    # @param path [String] the file where to write the modified file too
    def write_audio_file(path)
      out_file = File.open(path, 'w')
      out_file.write(audio_file_to_bytes)
    end

    # creates a byte array represented as a String (str.bytes) of the modified file data
    #
    # @return [String] the byte array of the file represented as a String
    def audio_file_to_bytes
      @id3v2_tag&.add_size_tag_if_not_present(audio_size_without_id3v2_tag)

      bytes = []
      bytes << @id3v2_tag.to_bytes unless @id3v2_tag.nil?
      bytes << read_audio_data
      bytes << @id3v1_tag.to_bytes unless @id3v1_tag.nil?

      bytes.inject([]) { |sum, x| sum + x.bytes }.pack('C*')
    end

    # reads the audio data part from the file
    #
    # @return [String] the byte array audio data part of the file represented as a String (str.bytes)
    def read_audio_data
      return @audio_data unless @audio_data.nil?

      @file.seek(@audio_start_index)
      @audio_data = @file.read(@audio_end_index - @audio_start_index)
      @audio_data
    end

    # returns the audio size without the id3v2 tag (note, if an id3v1 header is present, this size is included)
    #
    # @return [Integer] the size of the audio file without the id3v2 tag size
    def audio_size_without_id3v2_tag
      @audio_start_index - @file.size
    end

    private :parse_id3v2_tag, :parse_id3v1_tag, :audio_size_without_id3v2_tag
  end
end
