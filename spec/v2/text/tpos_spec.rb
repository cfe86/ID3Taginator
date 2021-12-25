# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::PartOfSetFrame do
  subject { Id3Taginator::Frames::Text::PartOfSetFrame }

  let!(:frame_id) { :TPOS }

  it 'reads part of set frame successful' do
    val = encode('1/2')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.part).to eq('1')
    expect(frame.total).to eq('2')
  end

  it 'reads part of set without total frame successful' do
    val = encode('1')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.part).to eq('1')
    expect(frame.total).to be_nil
  end

  it 'converts part of set frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '1', '2')

    expect(in_frame.part).to eq(parsed_frame.part)
    expect(in_frame.total).to eq(parsed_frame.total)
  end

  it 'converts part of set without total frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, '1', nil)

    expect(in_frame.part).to eq(parsed_frame.part)
    expect(in_frame.total).to eq(parsed_frame.total)
  end
end
