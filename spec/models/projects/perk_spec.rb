require 'spec_helper'

describe Projects::Perk do
  subject {FactoryGirl.build :projects_perk}
  it {should belong_to(:project)}
  it {should have_attached_file(:image)}
  it {should have_many(:pledges)}

  describe '#as_json' do
    it "should have the image path" do
      image = "perk_#{subject.id}_image"
      subject.as_json[image][:url_original].should == "/images/original/missing.png"
      subject.as_json[image][:url_large].should == "/images/large/missing.png"
      subject.as_json[image][:url_medium].should == "/images/medium/missing.png"
      subject.as_json[image][:url_small].should == "/images/small/missing.png"
    end
  end
  
  describe "abilities" do
    before :each do
      @member = FactoryGirl.create(:member, admin: false)
    end
    subject {Ability.new(@member)}

    describe "when I own the project" do
      before :each do
        @project = FactoryGirl.create :project, owner: @member
      end
      it {should be_able_to(:read, @project.perks.build)}
      it {should be_able_to(:create, @project.perks.build)}
      it {should be_able_to(:edit, @project.perks.build)}
      it {should be_able_to(:destroy, @project.perks.build)}
    end

    describe "when I do not own the project" do
      before :each do
        @project = FactoryGirl.create :project
      end
      it {should_not be_able_to(:create, @project.perks.build)}
      it {should_not be_able_to(:edit, @project.perks.build)}
      it {should_not be_able_to(:destroy, @project.perks.build)}
      describe "if the project is published" do
        before(:each) do
          @project.published = true
          @project.save!
        end
        it {should be_able_to(:read, @project.perks.build)}
      end
      describe "if the project is not yet published" do
        before(:each) {@project.published = false}
        it {should_not be_able_to(:read, @project.perks.build)}
      end
    end
  end
end
