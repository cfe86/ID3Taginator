# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::TitleSortOrderFrame do
  subject { Id3Taginator::Frames::Text::TitleSortOrderFrame }

  let!(:frame_id) { :TSOT }

  it 'reads title sort order frame successful' do
    val = encode('title sort')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.title).to eq('title sort')
  end

  it 'converts the title sort order frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'title sort')

    expect(in_frame.title).to eq(parsed_frame.title)
  end
end
