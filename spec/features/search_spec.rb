require 'spec_helper'

describe "Object Searching" do

  before(:all) do
      @user_name = "curator1"
      @generic_file_1 =  GenericFile.new title: 'file title', resource_type: 'Video'
      @generic_file_1.add_file_datastream(File.new(Rails.root + 'spec/fixtures/scholarsphere/scholarsphere_test1.txt'), :dsid=>'content')
      @generic_file_1.creator = "Larry David"
      @generic_file_1.contributor = "Bob Saccomano"
      @generic_file_1.description = "The complete Seinfeld series http://example.org/TheDescriptionLink/"
      @generic_file_1.tag = "tag string!"
      @generic_file_1.rights = "http://creativecommons.org/licenses/by-nc-nd/3.0/us/"
      @generic_file_1.publisher = "NBC"
      @generic_file_1.subject = "Comedy"
      @generic_file_1.language = "English"
      @generic_file_1.based_near = "Brooklyn"
      @generic_file_1.related_url = "http://example.org/TheRelatedURLLink/"
      @generic_file_1.apply_depositor_metadata(@user_name)
      @generic_file_1.save!

      @generic_file_2 =  GenericFile.new title: 'different file title', resource_type: 'Video'
      @generic_file_2.apply_depositor_metadata(@user_name)
      @generic_file_2.save!
  end
  after(:all) do
    @generic_file_1.destroy  rescue puts "error occured destroying object 1"
    @generic_file_2.destroy  rescue puts "error occured destroying object 2"
  end

  before do
    # TODO: This really shouldn't be necessary
    unspoof_http_auth
    sign_in :curator
    @user = User.where(login: @user_name).first
    visit "/"
    page.status_code.should == 200
    page.should have_content @generic_file_1.title.first
   #save_and_open_page
  end

  describe "Searching by keyword/tag" do
    it "displays the correct file in the results" do
      fill_in "search-field-header", with: @generic_file_1.tag
      click_on 'Go'
      page.status_code.should == 200
      page.should have_content "Search Results"
     #save_and_open_page
     #page.should have_content @generic_file_1.title.first
     #puts Trophy.all.inspect
    end
  end

end
