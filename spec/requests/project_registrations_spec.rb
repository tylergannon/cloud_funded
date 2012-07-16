require 'spec_helper'

feature "Registering a new project" do
  background do
    sign_in_member
  end
  scenario "A new project application should be generated for me." do
    visit root_path
    expect {
      click_link 'Get Funded'
    }.to change(Project, :count).by(1)
  end
  
  scenario "Filling out the application" do
    visit root_path
    click_link 'Get Funded'
    page.should have_content('Rules and Regulations')
    page.should have_selector('input[type=submit]')
    click_button 'I Agree!  Let''s Go.'
    page.should have_content('Company Basics')
    
    fill_in 'project_name', with: 'My Company'
    fill_in 'project_tagline', with: 'Something Catchy'
    fill_in 'project_short_description', with: 'A brief history of time'
    click_button 'Save and Continue'
    page.should have_content('More About You')
  end
  
  scenario "Uploading a file", js: true do
    go_to_company_basics_page
    page.should have_selector('img[alt=\'Project Image Placeholder\'][id=project_image_tag]')
    page.find('.upload_status').should_not be_visible
    attach_file 'project_image', File.expand_path('spec/support/images/bettersheen.jpeg')
    wait_until(1) do
      page.find('.upload_status').visible?
    end
    puts "ok, uploading"
    wait_until(10) do
      !page.find('.upload_status').visible?
      # page.has_selector?('img[alt=\'Project Image\'][id=project_image_tag]')
    end
    page.should have_selector('img[alt=\'Project Image\'][id=project_image_tag]')
    visit current_url
    page.should have_selector('img[alt=\'Project Image\'][id=project_image_tag]')
    
  end
end


# describe "ProjectRegistrations" do
#   describe "GET /project_registrations" do
#     it "works! (now write some real specs)" do
#       # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#       get project_registrations_path
#       response.status.should be(200)
#     end
#   end
# end
