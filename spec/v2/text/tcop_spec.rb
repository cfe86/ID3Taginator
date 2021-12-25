# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::CopyrightFrame do
  subject { Id3Taginator::Frames::Text::CopyrightFrame }

  let!(:frame_id) { :TCOP }

  it 'reads copyright frame successful' do
    val = encode('2021 Copyright Holder Copyright © ')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.year).to eq('2021')
    expect(frame.holder).to eq('Copyright Holder')
  end

  it 'converts the copyright frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 2021, 'Copyright Holder')

    expect(in_frame.year).to eq(parsed_frame.year)
    expect(in_frame.holder).to eq(parsed_frame.holder)
  end
end
