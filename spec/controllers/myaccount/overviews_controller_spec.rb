require  'spec_helper'

describe Myaccount::OverviewsController do
  render_views

  before(:each) do
    activate_authlogic

    @user = create(:user)
    login_as(@user)
    stub_redirect_to_welcome
  end

  it "show action should render show template" do
    get :show
    response.should render_template(:show)
  end

  it "show action should render show template" do
    @address = create(:address, :addressable => @user)
    @user.stubs(:shipping_address).returns(@address)
    get :show
    response.should render_template(:show)
  end

  it "edit action should render edit template" do
    get :edit
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    User.any_instance.stubs(:valid?).returns(false)
    User.any_instance.stubs(:valid_password?).returns(true)
    put :update, :user => @user.attributes.reject {|k,v| ![ 'first_name', 'last_name', 'password','birth_date'].include?(k)}
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    User.any_instance.stubs(:valid?).returns(false)
    User.any_instance.stubs(:valid_password?).returns(false)
    put :update, :user => @user.attributes.reject {|k,v| ![ 'first_name', 'last_name', 'password','birth_date'].include?(k)}
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    User.any_instance.stubs(:valid?).returns(true)
    User.any_instance.stubs(:valid_password?).returns(true)
    put :update, :user => @user.attributes.reject {|k,v| ![ 'first_name', 'last_name', 'password','birth_date'].include?(k)}
    response.should redirect_to(myaccount_overview_url())
  end

  it "update action should redirect when model is valid" do
    User.any_instance.stubs(:valid?).returns(true)
    User.any_instance.stubs(:valid_password?).returns(false)
    put :update, :user => @user.attributes.reject {|k,v| ![ 'first_name', 'last_name', 'password','birth_date'].include?(k)}
    response.should render_template(:edit)
  end
end

describe Myaccount::OverviewsController do
  render_views

  it "not logged in should redirect to login page" do
    stub_redirect_to_welcome
    get :show
    response.should redirect_to(login_url)
  end
end