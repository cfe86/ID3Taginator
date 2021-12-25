# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Url::UserUrlLinkFrame do
  subject { Id3Taginator::Frames::Url::UserUrlLinkFrame }

  let!(:frame_id) { :WXXX }

  it 'reads user url link frame frame successful' do
    val = "#{encode('abc')}https://wwww.my-homepage.com"

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.description).to eq('abc')
    expect(frame.url).to eq('https://wwww.my-homepage.com')
  end

  it 'converts the user url link frame frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'abc', 'https://wwww.my-homepage.com')

    expect(in_frame.description).to eq(parsed_frame.description)
    expect(in_frame.url).to eq(parsed_frame.url)
  end
end
