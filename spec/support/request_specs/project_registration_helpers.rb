module RequestSpecs
  module ProjectRegistrationHelpers
    def go_to_company_basics_page
      visit root_path
      click_link 'Get Funded'
      click_button 'I Agree!  Let''s Go.'
    end
  end
end