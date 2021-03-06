require 'rails_helper'
require 'capybara/email/rspec'

RSpec.feature 'Subscribing to alerts', elasticsearch: true do
  context 'when already signed in' do
    before(:each) do
      @user = create(:user, email: 'test@example.com')
      login_as @user, scope: :user
    end

    scenario 'given a search keyword, should be confirmed' do
      create(:opportunity, title: 'Food')

      visit opportunities_path
      fill_in :s, with: 'food'
      page.find('.filters__searchbutton').click

      expect(page).to have_content 'Subscribe to email alerts for food'

      click_button 'Subscribe'

      subscription = @user.subscriptions.first
      expect(subscription.search_term).to eq('food')

      expect(page).to have_content 'Your email alert has been created'
      expect(page).to have_content 'Search term: food'

      subscription.reload
      expect(subscription).to be_confirmed
    end

    scenario 'when a filter is provided, should be confirmed' do
      country = create(:country, name: 'Brazil')
      create(:opportunity, status: :publish, countries: [country])

      visit opportunities_path
      expect(page).not_to have_content 'Subscribe to email alerts'

      select 'Brazil', from: 'countries'
      page.find('.filters__searchbutton').click

      expect(page).to have_content 'Subscribe to email alerts for Brazil'

      click_button 'Subscribe'

      subscription = @user.subscriptions.first
      expect(subscription.search_term).to eq ''
      expect(subscription.countries.count).to eq 1
      expect(subscription.countries.first.name).to eq 'Brazil'

      expect(page).to have_content 'Your email alert has been created'
      expect(page).to have_content 'Brazil'

      subscription.reload
      expect(subscription).to be_confirmed
    end

    scenario 'can subscribe when multiple filters and search terms are provided, should be confirmed', js: true do
      country = create(:country, name: 'Italy')
      sector = create(:sector, name: 'Toys')
      type = create(:type, name: 'Magical')
      value = create(:value, name: 'Expensive')
      sentence = 'A company in Italy would like to buy transformers'

      create(
        :opportunity,
        title: sentence,
        status: :publish,
        countries: [country],
        sectors: [sector],
        types: [type],
        values: [value]
      )

      visit opportunities_path
      expect(page).not_to have_content 'Subscribe to email alerts for transformers, Italy, Toys, Magical, Expensive'

      fill_in :s, with: 'transformers'
      select 'Toys', from: 'sector', visible: false
      select 'Italy', from: 'countries[]', visible: false
      select 'Magical', from: 'types', visible: false
      select 'Expensive', from: 'values', visible: false

      page.find('.filters__searchbutton').click

      expect(page).to have_content 'Subscribe to email alerts for transformers, Italy, Toys, Magical, Expensive'

      click_button 'Subscribe'
      wait_for_ajax

      expect(page).to have_content 'Your email alert has been created'
      expect(page).to have_content 'Search term:'
      expect(page).to have_content 'transformers'
      expect(page).to have_content 'Italy'
      expect(page).to have_content 'Toys'
      expect(page).to have_content 'Magical'
      expect(page).to have_content 'Expensive'
    end

    scenario 'cannot subscribe when no search keywords or filters are provided' do
      visit opportunities_path
      expect(page).to have_no_content 'Subscribe to Email Alerts'
    end

    scenario 'can subscribe to all opportunities' do
      visit opportunities_path

      click_on 'Find opportunities'

      expect(page).to have_content 'Subscribe to email alerts for all opportunities'

      click_on 'Subscribe'

      expect(page).to have_content 'Your email alert has been created'
      expect(page).to have_content 'When we publish relevant opportunities'
    end
  end

  context 'when not signed in' do
    scenario 'can subscribe to email alerts' do
      mock_sso_with(email: 'test@example.com')

      create(:opportunity, title: 'Food')

      visit opportunities_path
      fill_in :s, with: 'food'
      page.find('.filters__searchbutton').click

      expect(page).to have_content 'Subscribe to email alerts for food'
      click_button 'Subscribe'

      expect(page).to have_content 'Your email alert has been created'
      expect(page).to have_content 'Search term: food'
    end
  end
end
