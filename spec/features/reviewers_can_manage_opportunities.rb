require 'rails_helper'

feature 'Reviewers can manage opportunities' do
  scenario 'can view opportunity list with pending/published/trash' do
    # should be able to view all opportunities, pending or not

    reviewer = create(:reviewer)
    login_as(reviewer)

    published_opportunity = create(:opportunity, status: 'publish')
    pending_opportunity = create(:opportunity, status: 'pending')
    trashed_opportunity = create(:opportunity, status: 'trash')

    visit admin_opportunities_path

    expect(page).to have_text(published_opportunity.title)
    expect(page).to have_text(pending_opportunity.title)
    expect(page).to have_text(trashed_opportunity.title)
  end

  scenario 'can view an individual non published opportunity' do
    reviewer = create(:reviewer)
    opportunity = create(:opportunity, author: reviewer, status: 'trash')

    login_as(reviewer)
    visit admin_opportunities_path
    click_on opportunity.title

    expect(page).to have_text(opportunity.teaser)
    expect(page).to have_text(opportunity.author.name)
  end

  scenario 'can set to trash their own draft opportunity' do
    reviewer = create(:reviewer)
    opportunity = create(:opportunity, author: reviewer, status: 'draft')

    login_as(reviewer)
    visit admin_opportunities_path
    click_on opportunity.title

    expect(page).to have_text(opportunity.teaser)
    expect(page).to have_text(opportunity.author.name)

    click_on 'Trash'

    expect(page.status_code).to eq 200
    expect(page).to have_content('This opportunity was moved to Trash')
  end

  scenario 'can set to draft from trash their own opportunity' do
    reviewer = create(:reviewer)
    opportunity = create(:opportunity, author: reviewer, status: 'trash')

    login_as(reviewer)
    visit admin_opportunities_path
    click_on opportunity.title
    expect(page).to have_text(opportunity.teaser)
    expect(page).to have_text(opportunity.author.name)

    click_on 'Draft'

    expect(page.status_code).to eq 200
    expect(page).to have_content('This opportunity has been set to draft')
  end

  scenario 'can set to pending from draft their own opportunity' do
    reviewer = create(:reviewer)
    opportunity = create(:opportunity, author: reviewer, status: 'draft')

    login_as(reviewer)
    visit admin_opportunities_path
    click_on opportunity.title

    expect(page).to have_text(opportunity.teaser)
    expect(page).to have_text(opportunity.author.name)

    click_on 'Pending'

    expect(page.status_code).to eq 200
    expect(page).to have_content('This opportunity has been set to pending')
  end

  scenario 'can not publish their own pending opportunity' do
    reviewer = create(:reviewer)
    opportunity = create(:opportunity, author: reviewer, status: 'pending')

    login_as(reviewer)
    visit admin_opportunities_path
    click_on opportunity.title

    expect(page).to have_text(opportunity.teaser)
    expect(page).to have_text(opportunity.author.name)
    expect(page).to_not have_button('Publish')
  end

  scenario 'can not edit opportunities from other users' do
    reviewer = create(:reviewer)
    another_uploader = create(:uploader, name: 'Mr Smith')
    opportunity = create(:opportunity, author: another_uploader, status: 'pending')

    login_as(reviewer)
    visit admin_opportunities_path
    click_on opportunity.title

    expect(page).to_not have_text('Edit opportunity')
  end

  scenario 'can edit opportunities that they create' do
    reviewer = create(:reviewer)
    opportunity = create(:opportunity, author: reviewer, status: 'pending')

    login_as(reviewer)
    visit admin_opportunities_path
    click_on opportunity.title

    expect(page).to have_text('Edit opportunity')
  end
end