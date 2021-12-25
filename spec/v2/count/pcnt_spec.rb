# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Count::PlayCounterFrame do
  subject { Id3Taginator::Frames::Count::PlayCounterFrame }

  let!(:frame_id) { :PCNT }

  it 'reads play count frame successful' do
    val = "\x00\x00\x10\x10"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.counter).to eq(4112)
  end

  it 'converts the play count frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 4112)

    expect(in_frame.counter).to eq(parsed_frame.counter)
  end
end
