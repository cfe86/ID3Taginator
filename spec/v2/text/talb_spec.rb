# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::AlbumFrame do
  subject { Id3Taginator::Frames::Text::AlbumFrame }

  let!(:frame_id) { :TALB }

  it 'reads album frame successful' do
    val = encode('My Album')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.album).to eq('My Album')
  end

  it 'converts the album frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'My Album')

    expect(in_frame.album).to eq(parsed_frame.album)
  end
end
