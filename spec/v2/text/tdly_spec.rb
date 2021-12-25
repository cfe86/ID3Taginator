# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::PlaylistDelayFrame do
  subject { Id3Taginator::Frames::Text::PlaylistDelayFrame }

  let!(:frame_id) { :TDLY }

  it 'reads playlist delay frame successful' do
    val = encode('123454321')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.delay).to eq('123454321')
  end

  it 'converts the playlist delay frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '123454321')

    expect(in_frame.delay).to eq(parsed_frame.delay)
  end
end
