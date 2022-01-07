# frozen_string_literal: true

module Id3Taginator
  class AudioFile
    include Extensions::Optionable

    attr_reader :id3v1_tag, :id3v2_tag

    def initialize(file, options = Options::Options.new, no_tag_parsing: false)
      @file = file
      @options = options

      parse_id3v2_tag unless no_tag_parsing
      parse_id3v1_tag unless no_tag_parsing
    end

    def parse_id3v1_tag
      length = @file.is_a?(File) ? @file.size : @file.length
      if length > 128
        @file.seek(-128, IO::SEEK_END)
        @id3v1_tag = Id3v1Tag.build_from_file(@file) if Id3v1Tag.id3v1_tag?(@file)
      end

      @audio_end_index = @id3v1_tag.nil? ? @file.size : @file.size - Id3v1Tag::TAG_SIZE
    end

    def parse_id3v2_tag
      @id3v2_tag = Id3v2Tag.build_from_file(@file, @options) if Id3v2Tag.id3v2_tag?(@file)
      @audio_start_index = @id3v2_tag.nil? ? 0 : @id3v2_tag.total_tag_size

      @id3v2_tag&.add_size_tag_if_not_present(audio_size_wo_id3v2_header)
    end

    def remove_id3v1_tag
      @id3v1_tag = nil
    end

    def create_id3v1_tag
      remove_id3v1_tag
      @id3v1_tag = Id3v1Tag.new
      @id3v1_tag
    end

    def remove_id3v2_tag
      @id3v2_tag = nil
    end

    def create_id3v2_2_tag
      remove_id3v2_tag
      @id3v2_tag = Id3v2Tag.build_for_version(2, @options)
      @id3v2_tag
    end

    def create_id3v2_3_tag
      remove_id3v2_tag
      @id3v2_tag = Id3v2Tag.build_for_version(3, @options)
      @id3v2_tag
    end

    def create_id3v2_4_tag
      remove_id3v2_tag
      @id3v2_tag = Id3v2Tag.build_for_version(4, @options)
      @id3v2_tag
    end

    def write_audio_file(path)
      out_file = File.open(path, 'w')
      out_file.write(audio_file_to_byte)
    end

    def audio_file_to_byte
      @id3v2_tag&.add_size_tag_if_not_present(audio_size_wo_id3v2_header)

      bytes = []
      bytes << @id3v2_tag.to_bytes unless @id3v2_tag.nil?
      bytes << audio_data
      bytes << @id3v1_tag.to_bytes unless @id3v1_tag.nil?

      bytes.inject([]) { |sum, x| sum + x.bytes }.pack('C*')
    end

    def audio_data
      @file.seek(@audio_start_index)
      @file.read(@audio_end_index - @audio_start_index)
    end

    def audio_size_wo_id3v2_header
      @audio_start_index - @file.size
    end

    private :parse_id3v2_tag, :parse_id3v1_tag
  end
end
