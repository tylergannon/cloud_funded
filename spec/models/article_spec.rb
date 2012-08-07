require 'spec_helper'

describe Article do
  before :each do
    stub_attachments_for(Project)
  end
  subject {FactoryGirl.create(:article)}
  
  it {should belong_to(:project)}
  it {should validate_presence_of(:author)}
  
  it "should reset the published at time when published." do
    subject.should_receive(:published_at=)
    subject.publish!
  end
  
  describe "permissions" do
    describe "Regular people" do
      before :each do
        @member = FactoryGirl.create(:member, admin: false)
      end
      subject {Ability.new(@member)}
      it {should_not be_able_to(:read, FactoryGirl.build(:article, published: false))}
      it {should be_able_to(:read, FactoryGirl.build(:published_article))}

      it {should_not be_able_to(:read, FactoryGirl.build(:article, published: false))}
      it {should_not be_able_to(:create, FactoryGirl.build(:article))}
      it {should_not be_able_to(:edit, FactoryGirl.build(:article))}
      it {should_not be_able_to(:destroy, FactoryGirl.build(:article))}
      
      describe "for project updates" do
        describe "when I own the project" do
          before :each do
            @project = FactoryGirl.create :project, owner: @member
          end
          it {should be_able_to(:manage, @project.articles.build(published: true))}
        end

        describe "when I don't own the project" do
          before :each do
            @project = FactoryGirl.create :project
          end
          it {should be_able_to(:read, FactoryGirl.build( :published_article, project: @project))}
          it {should_not be_able_to(:read, @project.articles.build(published: false))}
          it {should_not be_able_to(:edit, @project.articles.build)}
          it {should_not be_able_to(:create, @project.articles.build)}
          it {should_not be_able_to(:destroy, @project.articles.build)}
        end
      end
    end
  end
end
