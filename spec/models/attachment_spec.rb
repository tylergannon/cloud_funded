require 'spec_helper'

describe Attachment do
  subject {FactoryGirl.build :attachment}
  it {should have_attached_file(:image)}
  # it "should have attached file" do
  #   VCR.use_cassette 'Upload Image', erb: {paperclip: subject} do
  #     subject.should have_attached_file(:image)
  #   end
  # end
  it {should belong_to(:attachable)}
# , erb: {paperclip: subject} 

  it "validate presence of attachment" do
    VCR.use_cassette 'Check Image Presence' do
      subject.should validate_presence_of(:image)
    end
  end
end
