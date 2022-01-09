# frozen_string_literal: true

module Id3Taginator
  class Id3v1Tag
    include Extensions::Encodable

    IDENTIFIER = 'TAG'
    TAG_SIZE = 128

    attr_reader :title, :artist, :album, :year, :comment, :track, :genre

    # checks if the given stream contains a id3v1 tag
    #
    # @param file [StringIO, IO, File] the file stream to check
    #
    # @return [Boolean] true if contains an id3v1 tag, else false
    def self.id3v1_tag?(file)
      tag = file.read(3)
      file.seek(-3, IO::SEEK_CUR)

      tag == IDENTIFIER
    end

    # builds an id3tag from the given file stream
    #
    # @param file [StringIO, IO, File] the file stream
    #
    # @return [Id3v1Tag] the id3v1tag object
    def self.build_from_file(file)
      tag = file.read(3)
      unless tag == IDENTIFIER
        raise Errors::Id3TagError, "#{tag} is no valid Id3v1 identifier. The Tag seems to be corrupted."
      end

      title = file.read(30)&.strip
      artist = file.read(30)&.strip
      album = file.read(30)&.strip
      year = file.read(4)
      comment = file.read(28)
      track_flag = file.readbyte
      track = nil
      if track_flag.zero?
        track = file.readbyte
      else
        comment += track_flag.chr + file.readbyte.chr
      end
      comment = comment&.strip
      genre = Genres.genre(file.readbyte)

      new(title, artist, album, year, comment, track, genre)
    end

    # Constructor
    #
    # @param title [String, nil] the title
    # @param artist [String, nil] the artist
    # @param album [String, nil] the album title
    # @param year [Integer, String, nil] the year
    # @param comment [String, nil] the comment
    # @param track [Integer, nil] the track number
    # @param genre [Symbol, nil] the genre name as a Symbol, e.g. :ROCK
    def initialize(title = nil, artist = nil, album = nil, year = nil, comment = nil, track = nil, genre = :INVALID)
      @title = title
      @artist = artist
      @album = album
      @year = year
      @comment = comment
      @track = track
      @genre = genre
    end

    # sets a title, up to 30 characters
    #
    # @param title [String] the title
    def title=(title)
      raise Errors::Id3TagError, 'Title can\'t be longer than 30 characters.' if title.length > 30

      @title = title
    end

    # sets an artist, up to 30 characters
    #
    # @param artist [String] the artist
    def artist=(artist)
      raise Errors::Id3TagError, 'Artist can\'t be longer than 30 characters.' if artist.length > 30

      @artist = artist
    end

    # sets an album title, up to 30 characters
    #
    # @param album [String] the album title
    def album=(album)
      raise Errors::Id3TagError, 'Album can\'t be longer than 30 characters.' if album.length > 30

      @album = album
    end

    # sets a year, exactly 4 characters, e.g. 2021
    #
    # @param year [Integer, String] the year
    def year=(year)
      year = year.to_s
      raise Errors::Id3TagError, 'Year must be 4 characters.' if year.length != 4

      @year = year
    end

    # sets a comment, up to 30 characters
    #
    # @param comment [String] the comment
    def comment=(comment)
      raise Errors::Id3TagError, 'Comment can\'t be longer than 30 characters.' if comment.length > 30

      @comment = comment
    end

    # sets a genre, this must be a SYM from the Genre list in Genres, e.g. :ROCK
    #
    # @param genre_name [Symbol] the genre name as symbol, e.g. :ROCK
    def genre=(genre_name)
      @genre = genre_name.to_sym
    end

    # sets a track number
    #
    # @param track [Integer] the track, 0 < track# <= 255
    def track=(track)
      track = track.to_i
      raise Errors::Id3TagError, 'Track must be > 0 and < 255.' if !track.nil? && (track.negative? || track > 255)

      @track = track
    end

    # dumps the id3v1 tag to a string representing the bytes
    #
    # @return [String] id3v1 byte dump as a string. tag.bytes returns the bytes of the dump
    def to_bytes
      res = 'TAG'
      res += pad_left(@title.nil? ? '' : @title, 30)
      res += pad_left(@artist.nil? ? '' : @artist, 30)
      res += pad_left(@album.nil? ? '' : @album, 30)
      res += pad_left(@year.nil? ? '' : @year&.to_s, 4)
      if @track.nil?
        res += pad_left(@comment.nil? ? '' : @comment, 30)
      else
        res += pad_left(@comment.nil? ? '' : @comment, 28)
        res += 0.chr
        res += @track.chr
      end
      res += Genres.genre_by_name(@genre).chr

      res
    end
  end
end
