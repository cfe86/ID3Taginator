# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::InitialKeyFrame do
  subject { Id3Taginator::Frames::Text::InitialKeyFrame }

  let!(:frame_id) { :TKEY }

  it 'reads initial key frame successful' do
    val = encode('Cbm')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.initial_key).to eq('Cbm')
  end

  it 'converts the initial key  frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'Cbm')

    expect(in_frame.initial_key).to eq(parsed_frame.initial_key)
  end
end
