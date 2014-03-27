require_relative './feature_spec_helper'

class FakeHeaderAuthenticatableStrategy < ::Devise::Strategies::Base

  # Called if the user doesn't already have a rails session cookie
  def valid?
    true
  end

  def authenticate!
    u = User.where(login: 'curator1').first
    success!(u)
  end

end

describe "Visting the home page" do


  context "when logged in as a curator" do
    let(:current_user) { FactoryGirl.create(:curator) }

    around do |test|
      Warden::Strategies.add(:http_header_authenticatable, FakeHeaderAuthenticatableStrategy)
      test.run
      Warden::Strategies.add(:http_header_authenticatable, Devise::Strategies::HttpHeaderAuthenticatable)
    end

    context "when we do not belong to any groups" do
      it "loads the page successfully" do
        visit '/'
        page.should have_content 'What is ScholarSphere?'
      end
    end

    context "when we belong to a couple of groups" do
      before do
        add_groups_to_current_user 2
      end
      it "loads the page successfully" do
        visit '/'
        page.should have_content 'What is ScholarSphere?'
      end
      it "shows that I'm logged in" do
        visit '/'
        page.should have_content current_user.login
      end
    end

    context "when we belong to a lot of groups" do
      before do
        add_groups_to_current_user 5 # See issue #17
      end
      it "loads the page successfully" do
        visit '/'
        page.should have_content 'What is ScholarSphere?'
      end
      it "shows that I'm logged in" do
        visit '/'
        page.should have_content current_user.login
      end
    end
  end

  def add_groups_to_current_user(number_of_groups)
    group_list_array = []
    (0..number_of_groups).each do |i|
      group_list_array << "umg/up.dlt.scholarsphere-admin.admin#{i}"
    end
    current_user.update_attribute(:group_list, group_list_array.join(';?;'))
    # groups_last_update can't be nil, otherwise @user.groups will be []
    # (see User.rb (def groups) )
    current_user.update_attribute(:groups_last_update, Time.now)
    current_user.save!
  end

end