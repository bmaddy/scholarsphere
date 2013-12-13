require 'spec_helper'

describe "User Profile" do

  before do
    # TODO: This really shouldn't be necessary
    unspoof_http_auth
    sign_in :curator
    @current_user = User.where(login:"curator1")[0]
    @user = FactoryGirl.find_or_create(:user)
    @current_user.follow(@user)
    @user.follow(@current_user)
    @current_user.linkedin_handle = "abc"
    event = @current_user.create_event("test event", Time.new)
    @current_user.log_profile_event(event)
    @current_user.save!
    @user.save!
    visit "/"
    click_link "curator1"
  end

  it "should be displayed" do

    page.should have_content "Edit Your Profile"
    page.should have_content "Following: 1"
    page.should have_content "Following #{@user.name}"
    page.should have_content "Follower(s): 1"
    page.should have_content "Follower(s) #{@user.name}"
    page.should have_content "Linked In http://www.linkedin.com/in/#{@current_user.linkedin_handle}"
    click_link "Activity"
    save_and_open_page
    page.should have_content "test event"
  end

  it "should be editable" do
    click_link "Edit Your Profile"
    fill_in 'user_twitter_handle', with: 'curatorOfData'
    click_button 'Save Profile'
    page.should have_content "Your profile has been updated"
    page.should have_content "curatorOfData"
  end

  it "should display all users" do
    click_link "View Users"
    page.should have_xpath("//td/a[@href='/users/curator1']")
  end

  it "should allow searching through all users" do
    @archivist = FactoryGirl.find_or_create(:archivist)
    click_link "View Users"
    page.should have_xpath("//td/a[@href='/users/curator1']")
    page.should have_xpath("//td/a[@href='/users/archivist1']")
    fill_in 'user_search', with: 'archivist1'
    click_button "user_submit"
    page.should_not have_xpath("//td/a[@href='/users/curator1']")
    page.should have_xpath("//td/a[@href='/users/archivist1']")
  end
end
