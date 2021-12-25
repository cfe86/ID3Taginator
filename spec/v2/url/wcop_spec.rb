# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Url::CopyrightUrlFrame do
  subject { Id3Taginator::Frames::Url::CopyrightUrlFrame }

  let!(:frame_id) { :WCOP }

  it 'reads copyright url frame successful' do
    val = 'https://www.my-copyright-info.com'

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.url).to eq('https://www.my-copyright-info.com')
  end

  it 'converts the copyright url frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'https://www.my-copyright-info.com')

    expect(in_frame.url).to eq(parsed_frame.url)
  end
end
