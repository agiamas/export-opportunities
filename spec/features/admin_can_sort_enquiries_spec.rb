require 'rails_helper'

feature 'Admins sorting the list of enquiries', :elasticsearch, :commit do
  scenario 'Sort by company name' do
    publisher = create(:publisher)
    first_opportunity = create(:opportunity, title: 'Aardvark', created_at: 2.months.ago, response_due_on: 12.months.from_now)
    first_enquiry  = create(:enquiry, opportunity: first_opportunity, company_name: 'amazon')
    second_enquiry = create(:enquiry, opportunity: first_opportunity, company_name: 'zebra technologies')

    login_as(publisher)
    visit admin_enquiries_path

    # # Sorted in reverse date order by default
    expect(page.find('tbody tr:nth-child(1)').text).to have_content(second_enquiry.company_name)
    expect(page.find('tbody tr:nth-child(2)').text).to have_content(first_enquiry.company_name)

    click_on 'Company'

    # Sort by company name
    expect(page.find('tbody tr:nth-child(1)').text).to have_content(first_enquiry.company_name)
    expect(page.find('tbody tr:nth-child(2)').text).to have_content(second_enquiry.company_name)
  end

  scenario 'Sort by opportunity name' do
    publisher = create(:publisher)
    first_opportunity = create(:opportunity, title: 'Aardvark', created_at: 2.months.ago, response_due_on: 12.months.from_now)
    second_opportunity = create(:opportunity, title: 'Zebra', created_at: 2.months.ago, response_due_on: 12.months.from_now)
    create(:enquiry, opportunity: first_opportunity)
    create(:enquiry, opportunity: second_opportunity)

    login_as(publisher)
    visit admin_enquiries_path

    # # Sorted in reverse date order by default
    expect(page.find('tbody tr:nth-child(1)').text).to have_content(second_opportunity.title)
    expect(page.find('tbody tr:nth-child(2)').text).to have_content(first_opportunity.title)

    click_on 'Opportunity'

    # Sort by company name
    expect(page.find('tbody tr:nth-child(1)').text).to have_content(first_opportunity.title)
    expect(page.find('tbody tr:nth-child(2)').text).to have_content(second_opportunity.title)
  end

  scenario 'sorting when paginated' do
    skip('to implement')
    create(:enquiry, title: 'last opp')
    create_list(:enquiry, Admin::EnquiriesController::ENQUIRIES_PER_PAGE)

    login_as(create(:publisher))
    visit '/admin/opportunities?paged=2'
    within('.pagination') { click_link '2' }

    column_sort_link = page.find_link('Title')[:href]
    page_number = CGI.parse(URI.parse(column_sort_link).query)['paged'].first
    expect(page_number).to eq '1'
  end
end
