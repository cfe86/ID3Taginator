# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Tos::TermsOfUseFrame do
  subject { Id3Taginator::Frames::Tos::TermsOfUseFrame }

  let!(:frame_id) { :USER }

  it 'reads ToU frame successful' do
    val = "\x01eng#{encode("my text\nfor\nToS", add_encoding_byte: false, add_terminate_byte: false)}"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.language).to eq('eng')
    expect(frame.text).to eq("my text\nfor\nToS")
  end

  it 'converts the ToU frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'eng', "my text\nfor\nToS")

    expect(in_frame.language).to eq(parsed_frame.language)
    expect(in_frame.text).to eq(parsed_frame.text)
  end
end
