# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::InternetRadioStationFrame do
  subject { Id3Taginator::Frames::Text::InternetRadioStationFrame }

  let!(:frame_id) { :TRSN }

  it 'reads album frame successful' do
    val = encode('My Radio Station')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.station_name).to eq('My Radio Station')
  end

  it 'converts the album frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, 'My Radio Station')

    expect(in_frame.station_name).to eq(parsed_frame.station_name)
  end
end
