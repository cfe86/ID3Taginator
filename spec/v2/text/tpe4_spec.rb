# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::ModifiedByFrame do
  subject { Id3Taginator::Frames::Text::ModifiedByFrame }

  let!(:frame_id) { :TPE4 }

  it 'reads modified by frame successful' do
    val = encode("Modified By\nsecond line\nanother line")

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.modified_by).to eq("Modified By\nsecond line\nanother line")
  end

  it 'converts the modified by frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, "Modified By\nsecond line\nanother line")

    expect(in_frame.modified_by).to eq(parsed_frame.modified_by)
  end
end
