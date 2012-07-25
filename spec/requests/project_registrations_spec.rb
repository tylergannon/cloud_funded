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
    page.should have_content('Cool, Where is it located?')
  end
  
  scenario "Uploading a file", js: true do
    go_to_company_basics_page
    page.find('#image_placeholder_tag').should be_visible
    page.find('#image_tag').should_not be_visible
    page.find('.upload_status').should_not be_visible
    page.execute_script("$('.file_uploads').show();")

    attach_file 'image', File.expand_path('spec/support/images/bettersheen.jpeg')
    wait_until(10) do
      page.find('.upload_status').visible?
    end
    wait_until(10) do
      !page.find('.upload_status').visible?
    end
    page.find('#image_placeholder_tag').should_not be_visible
    page.find('#image_tag').should be_visible
    page.find('.upload_status').should_not be_visible
    visit current_url
    page.find('#image_placeholder_tag').should_not be_visible
    page.find('#image_tag').should be_visible
    page.find('.upload_status').should_not be_visible
  end
  
  scenario "Filling out 'More About Your Company' page" do
    go_to_more_about_your_company_page
    within 'form.edit_project' do
      page.should have_field('project_about_your_product')
      page.should have_field('project_how_it_helps')
      page.should have_field('project_your_target_market')
      page.should have_field('project_history')
    end
    
    within '.file_uploads' do
      page.should have_selector('input#about_your_product_image[type=file]')
      page.should have_selector('input#how_it_helps_image[type=file]')
      page.should have_selector('input#your_target_market_image[type=file]')
      page.should have_selector('input#history_image[type=file]')
    end
  end
  
  scenario "Submitting More About Your Company Page" do
    go_to_more_about_your_company_page
    within 'form.edit_project' do
      fill_in('project_about_your_product', with: 'blahblah')
      fill_in('project_how_it_helps', with: 'blahblah')
      fill_in('project_your_target_market', with: 'blahblah')
      fill_in('project_history', with: 'blahblah')
      click_button('Save and Continue')
    end
    page.should have_content('Perks go here.')
  end
  
  scenario "Fillout out fund raising options" do
    visit get_funded_path(id: 'fund_raise')
    fill_in 'Start date', with: '7/12/2012'
    fill_in 'End date', with: '10/22/2012'
    click_button 'Save And Continue'
    visit get_funded_path(id: 'fund_raise')
  end
  
  scenario "Filling out location", js: true do
    visit get_funded_path(id: 'where')
    fill_in 'project_address', with: '2131 Crosspoint Ave Santa Rosa CA'
    wait_until(10) do
      # puts "Your mom #{page.find('#answer').text}"
      page.has_selector?('#answer')
      # page.find('#answer').text == 'Ahhh. Santa Rosa.'
    end
    click_button 'Check Address'
    wait_until(2) do
      # page.has_selector?('#answer')
      page.find('#answer').text == 'Ahhh. Santa Rosa.'
    end
    page.should have_selector("#project_street_number[value='2131']")
    page.should have_selector("#project_route[value='Crosspoint Ave']")
    page.should have_selector("#project_city[value='Santa Rosa']")
    page.should have_selector("#project_county[value='Sonoma']")
    page.should have_selector("#project_state[value='CA']")
    page.should have_selector("#project_postal_code[value='95403']")
    click_button 'Save and Continue'
    @project = Project.last
    @project.street_number.should == '2131'
    @project.route.should == 'Crosspoint Ave'
    @project.city.should == 'Santa Rosa'
    @project.state.should == 'CA'
    @project.postal_code.should == '95403'
    @project.address.should == "2131 Crosspoint Ave, Santa Rosa, CA 95403, USA"
    @project.lat.should == 38.455489
    @project.long.should == -122.755758
    
  end
  
  scenario "Adding Perks" do
    visit get_funded_path(id: 'fund_raise')
    within '.perks div:first-child' do
      
    end
  end
  
  # scenario "Uploading a file to 'More About Your Company' page", js: true do
  #   go_to_more_about_your_company_page
  #   within '.field.about_your_product' do
  #     page.should have_selector('.upload_field .image_placeholder')
  #   end
  #   
  # end
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
