# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::MediaTypeFrame do
  subject { Id3Taginator::Frames::Text::MediaTypeFrame }

  let!(:frame_id) { :TMED }

  it 'reads media type frame successful' do
    val = encode('(VID/PAL/VHS)')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.media_type).to eq('(VID/PAL/VHS)')
  end

  it 'converts the media type frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '(VID/PAL/VHS)')

    expect(in_frame.media_type).to eq(parsed_frame.media_type)
  end
end
