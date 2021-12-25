# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::LanguageFrame do
  subject { Id3Taginator::Frames::Text::LanguageFrame }

  let!(:frame_id) { :TLAN }

  it 'reads languages frame successful' do
    val = encode("eng\x00ger\x00spa")

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.languages).to eq(%w[eng ger spa])
  end

  it 'converts the languages frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, %w[eng ger spa])

    expect(in_frame.languages).to eq(parsed_frame.languages)
  end
end
