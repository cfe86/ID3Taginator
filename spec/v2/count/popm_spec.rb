# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Count::PopularityFrame do
  subject { Id3Taginator::Frames::Count::PopularityFrame }

  let!(:frame_id) { :POPM }

  it 'reads popularity frame successful' do
    val = "my@email.com\x00\x10\x00\x00\x10\x10"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.email).to eq('my@email.com')
    expect(frame.rating).to eq(16)
    expect(frame.counter).to eq(4112)
  end

  it 'converts the popularity frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'my@email.com', 250, 4112)

    expect(in_frame.email).to eq(parsed_frame.email)
    expect(in_frame.rating).to eq(parsed_frame.rating)
    expect(in_frame.counter).to eq(parsed_frame.counter)
  end
end
