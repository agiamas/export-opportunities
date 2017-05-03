require 'rails_helper'

feature 'webops can monitor elastic search' do
  scenario 'basic check, all is OK' do
    visit '/data_sync_check'

    res = JSON.parse(page.body)
    pp res
    expect(res['status']).to eq('OK')

    save_and_open_page
  end

  scenario 'we have an Opportunity object missing in ES' do
    expect(OpportunityQuery).to receive(:new).with(a_hash_including(search_term: 'email@example.com drop-table opportunities')).and_call_original

  end

  scenario 'we have an Opportunity object missing in DB' do

  end

  scenario 'we have a Subscription missing in ES' do

  end

  scenario 'we have a Subscription missing in DB' do

  end
  # scenario 'list of enquiries can be paginated' do
  #   admin = create(:admin)
  #   allow(Enquiry).to receive(:default_per_page).and_return(1)
  #
  #   modern_enquiry = create(:enquiry, company_name: 'OCP')
  #   historic_enquiry = create(:enquiry, company_name: 'Ye Olde Company', created_at: Time.zone.local(1066, 10, 14))
  #
  #   login_as(admin)
  #   visit admin_opportunities_path
  #
  #   click_on 'Enquiries'
  #
  #   expect(page).to have_link(modern_enquiry.company_name)
  #   expect(page).not_to have_link(historic_enquiry.company_name)
  #
  #   click_on '2'
  #
  #   expect(page).not_to have_link(modern_enquiry.company_name)
  #   expect(page).to have_link(historic_enquiry.company_name)
  # end
  #
  # scenario 'view details of an enquiry' do
  #   admin = create(:admin)
  #   enquiry = create(:enquiry)
  #   login_as(admin)
  #   visit admin_opportunities_path
  #
  #   click_on 'Enquiries'
  #   expect(page).to have_content(enquiry.company_name)
  #
  #   click_on enquiry.company_name
  #
  #   expect(page).to have_link(enquiry.opportunity.title)
  #   expect(page).to have_content(enquiry.company_name)
  #   expect(page).to have_content(enquiry.email)
  #   expect(page).to have_content(enquiry.first_name)
  #   expect(page).to have_content(enquiry.last_name)
  #   expect(page).to have_content(enquiry.company_telephone)
  #   expect(page).to have_content(enquiry.company_address)
  #   expect(page).to have_content(enquiry.company_postcode)
  #   expect(page).to have_content(enquiry.company_url)
  #   expect(page).to have_content(enquiry.company_explanation)
  #   expect(page).to have_content(enquiry.company_sector)
  # end
  #
  # scenario 'download a csv of enquiries' do
  #   admin = create(:admin)
  #
  #   # We need quite a detailed setup here to allow us to check each field.
  #   country = create(:country)
  #   service_provider = create(:service_provider)
  #   opportunity = create(:opportunity, countries: [country], service_provider: service_provider)
  #   user = create(:user)
  #   enquiry = create(:enquiry, user: user, opportunity: opportunity, data_protection: true, created_at: 1.day.ago)
  #
  #   login_as(admin)
  #   visit admin_opportunities_path
  #
  #   click_on 'Enquiries'
  #   expect(page).to have_button('Download as CSV')
  #
  #   click_on 'Download as CSV'
  #
  #   expect(page.response_headers).to include 'Content-Type' => 'text/csv'
  #
  #   expect(page).to have_content(enquiry.company_name)
  #   expect(page).to have_content(enquiry.first_name)
  #   expect(page).to have_content(enquiry.last_name)
  #   expect(page).to have_content(enquiry.company_address)
  #   expect(page).to have_content(enquiry.company_postcode)
  #   expect(page).to have_content(enquiry.company_telephone)
  #   expect(page).to have_content(enquiry.created_at.strftime('%Y/%m/%d %H:%M'))
  #   expect(page).to have_content(enquiry.company_sector)
  #   expect(page).to have_content(enquiry.opportunity.title)
  #   expect(page).to have_content(enquiry.opportunity.countries[0].name)
  #   expect(page).to have_content(user.email)
  #   expect(page).to have_content(enquiry.opportunity.service_provider.name)
  #   expect(page).to have_content('Yes')
  #   expect(page).to have_content(enquiry.opportunity.id)
  #   expect(page).to have_content(enquiry.company_house_number)
  #   expect(page).to have_content(enquiry.company_url)
  #   expect(page).to have_content(enquiry.existing_exporter)
  #   expect(page).to have_content(enquiry.company_explanation)
  # end
  #
  # scenario 'download a csv of enquiries for a given date range.' do
  #   admin = create(:admin)
  #
  #   in_range = create(:enquiry, created_at: Date.new(2016, 6, 15))
  #   out_of_range = create(:enquiry, created_at: Date.new(2016, 7, 15))
  #
  #   login_as(admin)
  #   visit admin_opportunities_path
  #
  #   click_on 'Enquiries'
  #   expect(page).to have_button('Download as CSV')
  #
  #   select '2016', from: 'created_at_from_year'
  #   select 'June', from: 'created_at_from_month'
  #   select '1', from: 'created_at_from_day'
  #
  #   select '2016', from: 'created_at_to_year'
  #   select 'July', from: 'created_at_to_month'
  #   select '1', from: 'created_at_to_day'
  #
  #   click_on 'Download as CSV'
  #
  #   expect(page.response_headers).to include 'Content-Disposition' => 'attachment; filename="eig-enquiries-2016-06-01-2016-07-01.csv"'
  #   expect(page.response_headers).to include 'Content-Type' => 'text/csv'
  #
  #   expect(page).to have_content(in_range.company_name)
  #   expect(page).not_to have_content(out_of_range.company_name)
  # end
  #
  # scenario 'CSV includes all entries in range' do
  #   admin = create(:admin)
  #   enquiries = create_list(:enquiry, 50, created_at: 3.days.ago)
  #   login_as(admin)
  #   visit admin_opportunities_path
  #
  #   click_on 'Enquiries'
  #   expect(page).to have_button('Download as CSV')
  #
  #   week_ago = 7.days.ago
  #   select week_ago.year.to_s, from: 'created_at_from_year'
  #   select Date::MONTHNAMES[week_ago.month], from: 'created_at_from_month'
  #   select week_ago.day.to_s, from: 'created_at_from_day'
  #
  #   today = Time.zone.today
  #   select today.year.to_s, from: 'created_at_to_year'
  #   select Date::MONTHNAMES[today.month], from: 'created_at_to_month'
  #   select today.day.to_s, from: 'created_at_to_day'
  #
  #   click_on 'Download as CSV'
  #
  #   enquiries.each do |enquiry|
  #     expect(page).to have_content(enquiry.company_name)
  #   end
  # end
end




