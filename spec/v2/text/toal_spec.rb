# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::OriginalAlbumFrame do
  subject { Id3Taginator::Frames::Text::OriginalAlbumFrame }

  let!(:frame_id) { :TOAL }

  it 'reads original album frame successful' do
    val = encode('My Original Album')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.original_album).to eq('My Original Album')
  end

  it 'converts the original album frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'My Original Album')

    expect(in_frame.original_album).to eq(parsed_frame.original_album)
  end
end
