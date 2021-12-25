# frozen_string_literal: true

module Id3Taginator
  module Frames
    module EncryptionFrames
      include Frames::Frameable

      # extracts the audio encryptions (AENC/CRA)
      #
      # @return [Array<Frames::Encryption::Entities::AudioEncryption>] returns the Audio Encryptions
      def audio_encryptions
        frame = find_frames(Encryption::AudioEncryptionFrame.frame_id(@major_version, @options))
        return [] if frame.nil? || frame.empty?

        frame.map do |f|
          Encryption::Entities::AudioEncryption.new(f.owner_id, f.preview_start, f.preview_length, f.encryption_info)
        end
      end

      # adds an audio encryption. (AENC/CRA)
      # Multiple ones can be added, as long as they have different owner_ids
      #
      # @param enc [Frames::Encryption::Entities::AudioEncryption] the audio encryption
      def audio_encryptions=(enc)
        set_frame_fields_by_selector(Encryption::AudioEncryptionFrame,
                                     %i[@preview_start @preview_length @encryption_info],
                                     ->(f) { f.owner_id == enc.owner_id },
                                     enc.owner_id, enc.preview_start, enc.preview_length, enc.encryption_info)
      end

      alias add_audio_encryption audio_encryptions=

      # removes an audio encryption for the specific owner_id (AENC/CRA)
      #
      # @param owner_id [String] the owner_id
      def remove_audio_encryption(owner_id)
        @frames.delete_if do |f|
          f.identifier == Encryption::AudioEncryptionFrame.frame_id(@major_version, @options) && f.owner_id == owner_id
        end
      end

      # extracts the encryption methods (ENCR)
      #
      # @return [Array<Frames::Encryption::Entities::EncryptionMethod>] returns the Encryption Methods
      def encryption_methods
        frame = find_frames(Encryption::EncryptionMethodFrame.frame_id(@major_version, @options))
        return [] if frame.nil? || frame.empty?

        frame.map do |f|
          Encryption::Entities::EncryptionMethod.new(f.owner_id, f.method_symbol, f.encryption_data)
        end
      end

      # adds an encryption method. (ENCR)
      # Multiple ones can be added, as long as they have different owner_ids
      #
      # @param enc [Frames::Encryption::Entities::AudioEncryption] the audio encryption
      def encryption_methods=(enc)
        set_frame_fields_by_selector(Encryption::EncryptionMethodFrame,
                                     %i[@owner_id @method_symbol @encryption_data],
                                     ->(f) { f.owner_id == enc.owner_id },
                                     enc.owner_id, enc.method_symbol, enc.encryption_data)
      end

      alias add_encryption_method encryption_methods=

      # removes an encryption method for the specific owner_id (ENCR)
      #
      # @param owner_id [String] the owner_id
      def remove_encryption_method(owner_id)
        @frames.delete_if do |f|
          f.identifier == Encryption::EncryptionMethodFrame.frame_id(@major_version, @options) && f.owner_id == owner_id
        end
      end
    end
  end
end
