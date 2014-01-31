require 'spec_helper'

describe "Showing the Generic File" do

  before(:all) do
      @user_name = "curator1"
      @gf1 =  GenericFile.new title: 'file title', resource_type: 'Video'
      @gf1.apply_depositor_metadata(@user_name)
      @gf1.contributor = "Mohammad"
      @gf1.creator = "Allah"
      @gf1.description = "The work by Allah http://example.org/TheDescriptionLink/"
      @gf1.publisher = "Vertigo Comics"
      @gf1.subject = "Theology"
      @gf1.language = "Arabic"
      @gf1.based_near = "Medina, Saudi Arabia"
      @gf1.related_url = "http://example.org/TheRelatedURLLink/"
      @gf1.tag = "tag string!"
      @gf1.rights = "http://creativecommons.org/licenses/by-nc-nd/3.0/us/"
      @gf1.save!

      @gf2 =  GenericFile.new title: 'different file title', resource_type: 'Video'
      @gf2.apply_depositor_metadata(@user_name)
      @gf2.save!
  end
  after(:all) do
    @gf1.destroy  rescue puts "error occured destroying object"
  end

  before do
    # TODO: This really shouldn't be necessary
    unspoof_http_auth
    sign_in :curator
    @user = User.where(login: @user_name).first
  end

  context "User with generic files" do
    before do
      visit "/"
      click_link @gf1.title.first
    end

    it "loads the page" do
      page.status_code.should == 200
      page.should have_content @gf1.title.first
    end

    it "displays a link for creator" do
      check_page(@gf1.creator.first)
    end

    it "displays a link for contributor" do
      check_page(@gf1.contributor.first)
    end

    it "displays a link for publisher" do
      check_page(@gf1.publisher.first)
    end

    it "displays a link for subject" do
      check_page(@gf1.subject.first)
    end

    it "displays a link for language" do
      check_page(@gf1.language.first)
    end

    it "displays a link for based_near" do
      check_page(@gf1.based_near.first)
    end

    it "displays a link for tag" do
      check_page(@gf1.tag.first)
    end

    it "displays a link for rights" do
      check_page(@gf1.rights.first)
    end

    it "displays a link for all the linkable items" do
      page.should have_link 'http://example.org/TheDescriptionLink/'
      page.should have_link @gf1.related_url.first
    end
  end

  def check_page(link_name)
      page.should have_link link_name
      click_on link_name
      page.should have_content @gf1.title.first 
      page.should_not have_content @gf2.title.first 
  end
end
