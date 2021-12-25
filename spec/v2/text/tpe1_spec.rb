# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::ArtistsFrame do
  subject { Id3Taginator::Frames::Text::ArtistsFrame }

  let!(:frame_id) { :TPE1 }

  it 'reads artist frame successful' do
    val = encode('My Artist1/My Artist2')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.artists).to eq(['My Artist1', 'My Artist2'])
  end

  it 'converts the artist frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, ['My Artist1', 'My Artist2'])

    expect(in_frame.artists).to eq(parsed_frame.artists)
  end
end
