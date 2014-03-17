require 'spec_helper'

include Warden::Test::Helpers

describe "Generic File uploading and downloading", js: true do

  let(:user) { FactoryGirl.find_or_create(:user) }
  let(:filename) { 'world.png' }

  before do
    login_js
  end

  after do
    User.destroy_all
    Batch.destroy_all # Not sure if this is needed - check sufia gem to see what batch is.
    GenericFile.destroy_all
  end

  it "Uploads successfully" do
    visit new_generic_file_path
    check "terms_of_service"
    test_file_path = Rails.root.join("spec/fixtures/#{filename}").to_s
    file_format = 'png (Portable Network Graphics)'
    page.execute_script(%Q{$("input[type=file]").css("opacity", "1").css("-moz-transform", "none");$("input[type=file]").attr('id',"fileselect");})
    attach_file("fileselect", test_file_path)
    click_button 'main_upload_start'
    page.should have_content 'Apply Metadata'
    fill_in 'generic_file_tag', with: 'test_generic_file_tag'
    fill_in 'generic_file_creator', with: 'test_generic_file_creator'
    select 'Attribution-NonCommercial-NoDerivs 3.0 United States', from: 'generic_file_rights'
    click_on 'upload_submit'
    page.should have_content 'My Dashboard'
    page.should have_content filename
  end

  context "After a file has been uploaded" do
    before do
      @user_name = user.name
      @generic_file =  GenericFile.new title: 'file title', resource_type: 'Video'
      @generic_file.add_file_datastream(File.new(Rails.root + "spec/fixtures/#{filename}"))
      @generic_file.creator = "Larry David"
      @generic_file.contributor = "Bob Saccomano"
      @generic_file.description = "The complete Seinfeld series http://example.org/TheDescriptionLink/"
      @generic_file.tag = "tag string!"
      @generic_file.rights = "http://creativecommons.org/licenses/by-nc-nd/3.0/us/"
      @generic_file.publisher = "NBC"
      @generic_file.subject = "Comedy"
      @generic_file.language = "English"
      @generic_file.based_near = "Brooklyn"
      @generic_file.related_url = "http://example.org/TheRelatedURLLink/"
      @generic_file.apply_depositor_metadata(@user_name)
      @generic_file.save!
    end

    it "Can be successfully downloaded from the generic file show page" do
      visit '/dashboard' 
      page.should have_content 'My Dashboard'
      click_link @generic_file.title.first
      click_link 'Download'
     #expected_disposition = "attachment; filename=\"#{@generic_file.filename}\""
     #page.response_headers["Content-Disposition"].should == expected_disposition
     #puts page.response_headers["Content-Disposition"]
     # puts "%%%%%%%%%%%%%%%%%%%%%%%%   #{page.body}"
      #page.response_headers["Content-Type"].should == "application/octet-stream"
    end

  # it "Can be successfully downloaded from the dashboard" do
  #   visit '/dashboard' 
  #   page.should have_content 'My Dashboard'
  #   select 'Download File', from: 'Select an action'
  #   expected_disposition = "attachment; filename=\"#{@generic_file.filename.file.filename}\""
  #   page.response_headers["Content-Disposition"].should == expected_disposition
  # end
  end
end
