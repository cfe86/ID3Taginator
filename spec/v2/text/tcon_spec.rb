# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Text::GenreFrame do
  subject { Id3Taginator::Frames::Text::GenreFrame }

  let!(:frame_id) { :TCON }

  it 'parses genres correctly' do
    g = Id3Taginator::Frames::Text::GenreFrame.build_frame(['genre'])

    genre = 'my example'
    res = g.send(:parse_genres, genre)
    expect(res).to eq(['my example'])

    genre = '(18)'
    res = g.send(:parse_genres, genre)
    expect(res).to eq(['18'])

    genre = '(18)(8)(255)'
    res = g.send(:parse_genres, genre)
    expect(res).to eq(%w[18 8 255])

    genre = '(18)((my custom)(255)'
    res = g.send(:parse_genres, genre)
    expect(res).to eq(['18', 'my custom', '255'])

    genre = '(18)my custom(255)'
    res = g.send(:parse_genres, genre)
    expect(res).to eq(['18', 'my custom', '255'])

    genre = '(18)(RX)(CR)(255)'
    res = g.send(:parse_genres, genre)
    expect(res).to eq(%w[18 RX CR 255])
  end

  it 'reads genre frame successful' do
    val = encode('(18)((my custom)(RX)(CR)(137)')

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.genres).to eq([:TECHNO, 'my custom', 'Remix', 'Cover', :HEAVY_METAL])
  end

  it 'converts the genre frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, [:TECHNO, 'my custom', 'Remix', 'Cover', :HEAVY_METAL])

    expect(in_frame.genres).to eq(parsed_frame.genres)
  end
end
