# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Id3Taginator do
  it 'creates a global option and applies to all following files' do
    taginator = Id3Taginator.global_options.ignore_v23_frame_error(false).tag_padding(15)
    audio_bytes = '00010203 04050607 08091011'
    audio_file = taginator.build_by_bytes(audio_bytes)

    options = audio_file.instance_variable_get('@options')

    expect(options.padding_bytes).to eq(15)
    expect(options.ignore_v23_frame_error).to be_falsey

    audio_file2 = taginator.build_by_bytes(audio_bytes)

    options2 = audio_file2.instance_variable_get('@options')

    expect(options2.padding_bytes).to eq(15)
    expect(options2.ignore_v23_frame_error).to be_falsey
  end

  it 'creates a local option and applies to all following files' do
    options = Id3Taginator::Options::Options.new(Encoding::UTF_16, Encoding::UTF_8, 15, false)
    audio_bytes = '00010203 04050607 08091011'
    audio_file = Id3Taginator.build_by_bytes(audio_bytes, options)

    options = audio_file.instance_variable_get('@options')

    expect(options.padding_bytes).to eq(15)
    expect(options.ignore_v23_frame_error).to be_falsey

    audio_file.default_encode_for_destination(Encoding::UTF_8)
    expect(options.default_encode_dest).to eq(Encoding::UTF_8)
  end
end
