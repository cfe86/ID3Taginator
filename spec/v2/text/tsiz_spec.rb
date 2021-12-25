# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::SizeFrame do
  subject { Id3Taginator::Frames::Text::SizeFrame }

  let!(:frame_id) { :TSIZ }

  it 'reads size frame successful' do
    val = encode('1234567')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.size).to eq('1234567')
  end

  it 'converts the size frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '1234567')

    expect(in_frame.size).to eq(parsed_frame.size)
  end
end
