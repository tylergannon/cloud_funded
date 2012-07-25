module RequestSpecs
  module ProjectRegistrationHelpers
    def go_to_company_basics_page
      visit root_path
      click_link 'Get Funded'
      click_button 'I Agree!  Let''s Go.'
    end
    
    def go_to_more_about_your_company_page
      go_to_company_basics_page
      fill_in 'project_name', with: 'My Company'
      fill_in 'project_tagline', with: 'Something Catchy'
      fill_in 'project_short_description', with: 'A brief history of time'
      click_button 'Save and Continue'
      page.should have_content('Cool, Where is it located?')
      click_button 'Save and Continue'
    end
  end
end