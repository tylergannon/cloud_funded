require 'spec_helper'

describe Attachment do
  subject {FactoryGirl.create :attachment}
  it {should have_attached_file(:image)}
  it {should belong_to(:attachable)}
end
