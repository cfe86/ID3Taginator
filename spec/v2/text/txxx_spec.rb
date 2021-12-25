# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::UserTextInfoFrame do
  subject { Id3Taginator::Frames::Text::UserTextInfoFrame }

  let!(:frame_id) { :TXXX }

  it 'reads user text frame frame successful' do
    val = "#{encode('abc')}#{encode('def', add_encoding_byte: false, add_terminate_byte: false)}"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.description).to eq('abc')
    expect(frame.content).to eq('def')
  end

  it 'converts the user text frame frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'abc', 'def')

    expect(in_frame.description).to eq(parsed_frame.description)
    expect(in_frame.content).to eq(parsed_frame.content)
  end
end
