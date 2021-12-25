# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Id3Taginator::AudioFile do
  it 'overwrites picture if descriptor is used twise' do
    audio_bytes = '00010203 04050607 08091011'
    audio_file = Id3Taginator.build_by_file(hex_string_to_byte_stream(audio_bytes))

    frames = Id3Taginator::Frames

    expect(audio_file.id3v2_tag).to be_nil
    tag = audio_file.create_id3v2_3_tag
    tag.add_picture(frames::Picture::Entities::Picture.new('images/png', :COVER_FRONT,
                                                           'description', 'front cover'))
    tag.add_picture(frames::Picture::Entities::Picture.new('images/png', :COVER_BACK,
                                                           'description', 'back cover'))
    tag.add_picture(frames::Picture::Entities::Picture.new('images/png', :COVER_FRONT,
                                                           'description2', 'front cover2'))

    pictures = tag.pictures
    expect(pictures.length).to eq(2)
    cover_front = pictures.find { |p| p.picture_type == :COVER_FRONT }
    expect(cover_front.descriptor).to eq('description2')
    expect(cover_front.picture_data).to eq('front cover2')
  end
end
