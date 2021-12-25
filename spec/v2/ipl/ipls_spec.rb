# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Id3Taginator::Frames::Ipl::InvolvedPeopleFrame do
  subject { Id3Taginator::Frames::Ipl::InvolvedPeopleFrame }

  let!(:frame_id) { :IPLS }

  it 'reads involved people frame frame successful' do
    val = encode("involvement1\x00involvee1\x00involvement2\x00involvee2")

    frame = test_frame_from_bytes(subject, frame_id, val)

    expect(frame.involved_people.first.involvement).to eq('involvement1')
    expect(frame.involved_people.first.involvee).to eq('involvee1')
    expect(frame.involved_people[1].involvement).to eq('involvement2')
    expect(frame.involved_people[1].involvee).to eq('involvee2')
  end

  it 'converts the involved people frame to bytes' do
    in_frame, parsed_frame = test_frame_to_bytes(subject, [
                                                   Id3Taginator::Frames::Ipl::Entities::InvolvedPerson.new(
                                                     'involvement1',
                                                     'involvee1'
                                                   ),
                                                   Id3Taginator::Frames::Ipl::Entities::InvolvedPerson.new(
                                                     'involvement2',
                                                     'involvee12'
                                                   )
                                                 ])

    expect(in_frame.involved_people.first.involvement).to eq(parsed_frame.involved_people.first.involvement)
    expect(in_frame.involved_people.first.involvee).to eq(parsed_frame.involved_people.first.involvee)
    expect(in_frame.involved_people[1].involvement).to eq(parsed_frame.involved_people[1].involvement)
    expect(in_frame.involved_people[1].involvee).to eq(parsed_frame.involved_people[1].involvee)
  end
end
