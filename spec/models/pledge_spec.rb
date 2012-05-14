require 'spec_helper'

describe Pledge do
  subject {Factory :pledge}
  it {should belong_to(:project)}
  it {should belong_to(:investor)}
end
