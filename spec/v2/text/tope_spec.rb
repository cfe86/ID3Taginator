# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::OriginalArtistsFrame do
  subject { Id3Taginator::Frames::Text::OriginalArtistsFrame }

  let!(:frame_id) { :TOPE }

  it 'reads original artist frame successful' do
    val = encode('Artist1/Artist num 2/Artist 3')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.original_artists).to eq(['Artist1', 'Artist num 2', 'Artist 3'])
  end

  it 'converts the original artist frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, ['Artist1', 'Artist num 2', 'Artist 3'])

    expect(in_frame.original_artists).to eq(parsed_frame.original_artists)
  end
end
