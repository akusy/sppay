require 'spec_helper'

feature "User creates and sends query" do
  given(:offers) { IO.read("spec/fixtures/offers.json") }
  given(:no_offers) { IO.read("spec/fixtures/no_offers.json") }

  background do
    Rails.cache.clear
    Api::SpPay.any_instance.stub(:check_signature).and_return(true)
  end

  scenario "User receives response with offers" do
    stub_request(:get, /api.sponsorpay.com\/feed\/v1\/offers.json/).
      to_return(status: 200, body: offers, headers: {})

    visit "/"
    fill_in "Uid", with: "player1"
    fill_in "Pub0", with: "campaign2"
    click_button "Create Query"
    expect(page).to have_text("Title: Tap Fish Offer Payout: 90 Offer")
  end

  scenario "User receives response with no offers" do
    stub_request(:get, /api.sponsorpay.com\/feed\/v1\/offers.json/).
      to_return(status: 200, body: no_offers, headers: {})

    visit "/"
    fill_in "Uid", with: "player1"
    fill_in "Pub0", with: "campaign2"
    click_button "Create Query"
    expect(page).to have_text("No offers")
  end

  background do
    stub_request(:get, /api.sponsorpay.com\/feed\/v1\/offers.json/).
      to_return(status: 400, body: "", headers: {})
  end

  scenario "Request fails" do
    visit "/"
    fill_in "Uid", with: "player1"
    fill_in "Pub0", with: "campaign2"
    click_button "Create Query"

    expect(page).to have_text("No valid response, try again")
  end

  scenario "Invalid page as string" do
    visit "/"
    fill_in "Uid", with: "player1"
    fill_in "Pub0", with: "campaign2"
    fill_in "Page", with: "campaign2"
    click_button "Create Query"

    expect(page).to have_text("Page is not a number")
  end

  scenario "Invalid page as negative number" do
    visit "/"
    fill_in "Uid", with: "player1"
    fill_in "Pub0", with: "campaign2"
    fill_in "Page", with: -1
    click_button "Create Query"

    expect(page).to have_text("Page must be greater than 0")
  end

  scenario "Blank forms" do
    visit "/"
    fill_in "Uid", with: ""
    fill_in "Pub0", with: ""
    click_button "Create Query"

    expect(page).to have_text("Uid can't be blank. Pub0 can't be blank")
  end
end