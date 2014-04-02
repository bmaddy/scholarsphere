require 'spec_helper'

describe "Selecting files to import from cloud providers" do

  let(:user) { FactoryGirl.find_or_create(:user) }

  it "should have a Cloud file picker using browse-everything" do
    login_js
    visit '/'
    click_link 'Share Your Work'
    click_link "Cloud Providers"
    page.should have_content "Browse cloud files"
    page.should have_content "Submit selected files"
    page.should have_content "0 items selected"
    click_button 'Browse cloud files'
    page.should have_content "File System"
    click_link "File System"
    click_link "robots.txt"
    click_button "Submit"
    page.should have_content "1 files selected"
    check "terms_of_service"
    click_button "Submit 1 selected files"
    page.should have_content "Apply Metadata"
  end

end
