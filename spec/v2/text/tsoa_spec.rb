# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::AlbumSortOrderFrame do
  subject { Id3Taginator::Frames::Text::AlbumSortOrderFrame }

  let!(:frame_id) { :TSOA }

  it 'reads album sort order frame successful' do
    val = encode('album sort')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.album).to eq('album sort')
  end

  it 'converts the album sort order frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'album sort')

    expect(in_frame.album).to eq(parsed_frame.album)
  end
end
