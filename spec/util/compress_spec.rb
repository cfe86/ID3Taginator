# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Id3Taginator::Util::CompressUtil do
  it 'compresses' do
    str = 'abcdefghijklmnopqrstuvwxyz_abcdefghijklmnopqrstuvwxyz_abcdefghijklmnopqrstuvwxyz'
    compressed = Id3Taginator::Util::CompressUtil.compress_data(str)
    decompressed = Id3Taginator::Util::CompressUtil.decompress_data(compressed)

    expect(decompressed).to eq(str)
  end
end
