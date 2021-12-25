# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::AlbumArtistFrame do
  subject { Id3Taginator::Frames::Text::AlbumArtistFrame }

  let!(:frame_id) { :TPE2 }

  it 'reads album artist frame successful' do
    val = encode('My album artist')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.album_artist).to eq('My album artist')
  end

  it 'converts the album artist information frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'My album artist')

    expect(in_frame.album_artist).to eq(parsed_frame.album_artist)
  end
end
