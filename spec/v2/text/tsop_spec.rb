# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::PerformerSortOrderFrame do
  subject { Id3Taginator::Frames::Text::PerformerSortOrderFrame }

  let!(:frame_id) { :TSOP }

  it 'reads performer sort order frame successful' do
    val = encode('performer sort')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.performer).to eq('performer sort')
  end

  it 'converts the performer sort order frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'performer sort')

    expect(in_frame.performer).to eq(parsed_frame.performer)
  end
end
