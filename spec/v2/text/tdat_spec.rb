# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::DateFrame do
  subject { Id3Taginator::Frames::Text::DateFrame }

  let!(:frame_id) { :TDAT }

  it 'reads date frame successful' do
    val = encode('2109')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.day).to eq('21')
    expect(frame.month).to eq('09')
  end

  it 'converts the date frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '21', '09')

    expect(in_frame.day).to eq(parsed_frame.day)
    expect(in_frame.month).to eq(parsed_frame.month)
  end
end
