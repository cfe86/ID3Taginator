# frozen_string_literal: true

module Id3Taginator
  module Frames
    module UrlFrames
      include Frames::Frameable

      # extracts the commercial information url (WCOM/WCM)
      #
      # @return [String, nil] returns the URL
      def commercial_information_url
        find_frame(Url::CommercialUrlFrame.frame_id(@major_version, @options))&.url
      end

      # sets the commercial information url (WCOM/WCM)
      #
      # @param url [String] the url
      def commercial_information_url=(url)
        set_frame_fields(Url::CommercialUrlFrame, [:@url], url)
      end

      # extracts the copyright information url (WCOP/WCP)
      #
      # @return [String, nil] returns the URL
      def copyright_information_url
        find_frame(Url::CopyrightUrlFrame.frame_id(@major_version, @options))&.url
      end

      # sets the copyright information url (WCOP/WCP)
      #
      # @param url [String] the url
      def copyright_information_url=(url)
        set_frame_fields(Url::CopyrightUrlFrame, [:@url], url)
      end

      # extracts the official audio file url (WOAF/WAF)
      #
      # @return [String, nil] returns the URL
      def official_audio_file_url
        find_frame(Url::OfficialFileWebpageFrame.frame_id(@major_version, @options))&.url
      end

      # sets the official audio file url (WOAF/WAF)
      #
      # @param url [String] the url
      def official_audio_file_url=(url)
        set_frame_fields(Url::OfficialFileWebpageFrame, [:@url], url)
      end

      # extracts the official artist url (WOAR/WAR)
      #
      # @return [String, nil] returns the URL
      def official_artist_url
        find_frame(Url::OfficialArtistWebpageFrame.frame_id(@major_version, @options))&.url
      end

      # sets the official artist url (WOAR/WAR)
      #
      # @param url [String] the url
      def official_artist_url=(url)
        set_frame_fields(Url::OfficialArtistWebpageFrame, [:@url], url)
      end

      # extracts the official source url (WOAS/WAS)
      #
      # @return [String, nil] returns the URL
      def official_source_url
        find_frame(Url::OfficialSourceWebpageFrame.frame_id(@major_version, @options))&.url
      end

      # sets the official source url (WOAS/WAS)
      #
      # @param url [String] the url
      def official_source_url=(url)
        set_frame_fields(Url::OfficialSourceWebpageFrame, [:@url], url)
      end

      # extracts the official radio station url (WORS)
      #
      # @return [String, nil] returns the URL
      def official_radio_station_homepage
        find_frame(Url::OfficialAudioRadioStationHomepageFrame.frame_id(@major_version, @options))&.url
      end

      # sets the official radio station url (WORS)
      #
      # @param url [String] the url
      def official_radio_station_homepage=(url)
        set_frame_fields(Url::OfficialAudioRadioStationHomepageFrame, [:@url], url)
      end

      # extracts the official radio station url (WPAY)
      #
      # @return [String, nil] returns the URL
      def payment_url
        find_frame(Url::PaymentUrlFrame.frame_id(@major_version, @options))&.url
      end

      # sets the payment url (WPAY)
      #
      # @param url [String] the url
      def payment_url=(url)
        set_frame_fields(Url::PaymentUrlFrame, [:@url], url)
      end

      # extracts the official publisher url (WPUB/WPB)
      #
      # @return [String, nil] returns the URL
      def official_publisher_webpage
        find_frame(Url::OfficialPublisherWebpageFrame.frame_id(@major_version, @options))&.url
      end

      # sets the official publisher url (WPUB/WPB)
      #
      # @param url [String] the url
      def official_publisher_webpage=(url)
        set_frame_fields(Url::OfficialPublisherWebpageFrame, [:@url], url)
      end

      # extracts the user custom url links (WXXX/WXX)
      #
      # @return [Array<Frames::Url::Entities::UserInfo>] returns the custom URL links
      def user_custom_url_links
        frame = find_frames(Url::UserUrlLinkFrame.frame_id(@major_version, @options))
        return [] if frame.nil? || frame.empty?

        frame.map { |f| Url::Entities::UserInfo.new(f.description, f.url) }
      end

      # adds a user custom url link (WXXX/WXX)
      # Multiple ones can be added, as long as they have different description
      #
      # @param custom_url [Frames::Url::Entities::UserInfo] the custom url link to add
      def user_custom_url_link=(custom_url)
        set_frame_fields_by_selector(Url::UserUrlLinkFrame, %i[@url],
                                     ->(f) { f.description == custom_url.description },
                                     custom_url.url, custom_url.description)
      end

      alias add_user_custom_url_link user_custom_url_link=

      # removes a user custom url link for the specific description (WXXX/WXX)
      #
      # @param description [String] the description
      def remove_user_custom_url_link(description)
        @frames.delete_if do |f|
          f.identifier == Url::UserUrlLinkFrame.frame_id(@major_version, @options) &&
            f.description == description
        end
      end
    end
  end
end
