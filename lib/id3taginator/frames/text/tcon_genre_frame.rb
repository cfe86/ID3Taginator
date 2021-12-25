# frozen_string_literal: true

module Id3Taginator
  module Frames
    module Text
      class GenreFrame < Id3v2Frame
        include HasId

        frame_info :TCO, :TCON, :TCON

        attr_accessor :genres

        # builds the genre frame
        #
        # @param genres [Array<String, Symbol>, Symbol, String] the genre(s)
        # @param options [Options::Options] options to use
        # @param id3_version [Integer] the id3 version to build the frame for
        #
        # @return [Id3v2Frame] the resulting id3v2 frame
        def self.build_frame(genres, options = nil, id3_version: 3)
          supported?('TCON', id3_version, options)

          argument_not_empty(genres, 'genres')

          frame = new(frame_id(id3_version, options), 0, build_id3_flags(id3_version), '')
          frame.genres = genres.is_a?(Array) ? genres : [genres]
          frame
        end

        def process_content(content)
          genre_str = decode_using_encoding_byte(content)
          genre_ids = parse_genres(genre_str)

          @genres = []
          genre_ids.each do |g|
            next @genres << Genres.genre(g.to_i) if g.match(/^(\d)+$/)
            next @genres << 'Remix' if g == 'RX'
            next @genres << 'Cover' if g == 'CR'

            @genres << g
          end
        end

        def content_to_bytes
          raise Errors::Id3TagError, 'Genres can\'t be empty' if @genres.nil? || @genres.empty?

          encode_and_add_encoding_byte(genres_to_string(@genres))
        end

        def genres_to_string(genres)
          result = ''
          genres.each do |genre|
            g = Genres.genre_by_name(genre)
            g = g.is_a?(Integer) ? "(#{g})" : "((#{g})"
            g = '(RX)' if g == '((Remix)'
            g = '(CR)' if g == '((Cover)'

            result += g
          end

          result
        end

        def parse_genres(genres)
          result = []
          curr = ''
          is_started = false
          if genres[0] == '('
            is_started = true
            genres = genres[1..-1]
          end
          genres.each_char do |c|
            # genre has started, but nothing has parsed, so ( is opening for custom genre like ((my genre)
            next if c == '(' && curr.empty? && is_started

            if c == '(' && !curr.empty? && is_started
              is_started = false
              result << curr
              curr = ''
              next
            elsif c == ')' && is_started
              is_started = false
              result << curr
              curr = ''
              next
            elsif c == '(' && !is_started
              is_started = true
              next
            else
              is_started = true
              curr += c
            end
          end

          result << curr unless curr.empty?

          result.reject(&:empty?)
        end

        private :parse_genres
      end
    end
  end
end
