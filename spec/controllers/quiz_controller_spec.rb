require 'spec_helper'

# #Have to use a concrete controller type to test.
describe OlsController do
  render_views

  it "should get new only when logged-in" do
    get :new
    response.should_not be_success

    u = FactoryGirl.create(:user)
    sign_in :user, u
    
    get :new
    
    response.should be_success
    response.should render_template(:new)
    assigns(:item).should_not be_nil
  end

  it "should show ol" do
    ol = FactoryGirl.create(:ol_with_user)
    
    Ol.should_receive(:find_by_slug).with(ol.to_param).and_return(ol)
    
    get :show, id: ol.to_param
    
    response.should be_success
    response.should render_template('show')
    assigns(:item).should_not be_nil
  end

  it "should fail well for unknown ols" do
    get :show, id: 1
    response.should redirect_to :action => "index"
  end
  
  it "should get index" do
    Ol.should_receive(:all).and_return([FactoryGirl.create(:ol_with_user),FactoryGirl.create(:ol_with_user)])
    
    get :index
    
    response.should be_success
    response.should render_template(:index)
    assigns(:items).should_not be_nil
  end
  
  it "should show testall page for ol" do
    ol = FactoryGirl.create(:ol_with_user)
    Ol.any_instance.stub(:get_all_data).and_return(quiz_data)
    
    get :testall, id: ol.to_param
    response.should be_success
    response.should render_template(:test)
    assigns(:data).should_not be_nil
    assigns(:post_url).should_not be_nil
  end
  
  it "should accept quizall data" do
    # Use quiz data that's the numbers in binary.
    ol = FactoryGirl.create(:ol_with_user)
    u = FactoryGirl.create(:user)
    
    sign_in :user, u
    
    User.any_instance.should_receive(:add_record).with(ol, quiz_data).and_return(true)
    Ol.any_instance.should_receive(:mark).with(quiz_data).and_return(marked)
    Ol.any_instance.should_receive(:get_all_data).and_return(marked)
        
    put :quizall, id: ol.to_param, ans: quiz_data
    response.should be_success
    response.should render_template(:full_results)
    assigns(:data).should_not be_nil
    assigns(:results).should_not be_nil
  end
  
  it "should accept quizimprove data" do
    # Use quiz data that's the numbers in binary.
    ol = FactoryGirl.create(:ol_with_user)
    u = FactoryGirl.create(:user)
    
    sign_in :user, u

    u.add_record(ol, ol.mark(quiz_data))
    
    OlsController.any_instance.should_receive(:get_improvement_data).and_return(ol.get_all_data)
    User.any_instance.should_receive(:add_record).with(ol, marked)
    Ol.any_instance.should_receive(:mark).with(quiz_data).and_return(marked)
    
    put :quizimprove, id: ol.to_param, ans: quiz_data
    response.should be_success
    response.should render_template(:improve_results)
    assigns(:data).should_not be_nil
    assigns(:results).should_not be_nil
  end
  
  it "should show learning page for ol" do
    ol = FactoryGirl.create(:ol_with_user)

    0.upto(ol.get_chunk_count - 1).each do |chunk|
      # Ugh, this was written early. TODO use separate actions for each of the learn stages.
      0.upto(1).each do |page|
        get :learn, id: ol.to_param, page: (chunk*3 + page), ans: quiz_data
        
        response.should be_success
        assigns(:data).should_not be_nil
        assigns(:data).should == ol.get_chunk_data(chunk)
        
        if page == 0
          assigns(:test_url).should_not be_nil
          response.should render_template(:display)
        else
          assigns(:post_url).should_not be_nil
          response.should render_template(:test)
        end
      end
    end
  end
  
  it "should accept quiz data" do
    # Use quiz data that's the numbers in binary.
    ol = FactoryGirl.create(:ol_with_user)
    u = FactoryGirl.create(:user)
    
    sign_in :user, u
   
    0.upto(ol.get_chunk_count - 1).each do |chunk|
      page = 3 * chunk + 1

      if chunk == (ol.get_chunk_count - 1) 
        Ol.any_instance.should_receive(:mark).with(quiz_data)
        User.any_instance.should_receive(:add_record)
      end

      put :quiz, id: ol.to_param, page: page, ans: quiz_data
      
      response.should redirect_to :action => "learn", :page => page + 1, :id => ol.to_param
    end
  end
  
  it "should get edit iff owner logged in" do
    ol = FactoryGirl.create(:ol_with_user)
    
    sign_in :user, ol.owner

    Ol.any_instance.should_receive(:get_all_data).and_return(quiz_data)
    get :edit, id: ol.to_param
    response.should be_success
    assigns(:data).should_not be_nil
    response.should render_template(:edit)
    
    sign_out :user

    get :edit, id: ol.to_param
    response.should redirect_to(ol)
  end
  
  it "should create ol" do
    Ol.any_instance.stub(:valid?).and_return(true)
    
    # No log in, should fail
    lambda do
      post :create
    end.should_not change(Ol, :count)
    response.should_not be_success
    
    # #Log in, should work with valid ol
    sign_in :user, FactoryGirl.create(:user)
    
    # Should pass with valid OL
    OlsController.any_instance.should_receive(:item_update).twice
    lambda do
      post :create, ol: {name: 'something', 'asfd' => 'ghjkl'}
    end.should change(Ol, :count).from(0).to(1)
    response.should redirect_to Ol.first

    Ol.any_instance.stub(:valid?).and_return(false)
    
    # With invalid OL should fail
    lambda do
      post :create
    end.should_not change(Ol, :count)
    response.should render_template(:new)
  end

  it "should update ol" do
    ol = FactoryGirl.create(:ol_with_user)
    
    new_items = ['new', 'item', 'set']
    ol.attributes['items'] = (new_items.map { |item| item.to_s  }).join("\n")
    
    lambda do
      # Not logged in, fail
      put :update, id: ol.to_param, ol: ol.attributes
      response.should_not be_success
      response.should redirect_to :action => "show"
    
      # Logged in as someone else, fail
      u2 = FactoryGirl.create(:user)
      sign_in :user, u2
      put :update, id: ol.to_param, ol: ol.attributes
      response.should_not be_success
      response.should redirect_to :action => "show"
      sign_out :user
    end.should_not change(Ol.find(ol.id), :items)
    
    # Logged in as owner
    sign_in :user, ol.owner
    
    # Invalid, should fail
    ol.name = ""
    lambda do
      put :update, id: ol.to_param, ol: ol.attributes
    end.should_not change(Ol, :count)
    
    # Should succeed
    ol.name = 'name'
    put :update, id: ol.to_param, ol: ol.attributes
    ol.save
    response.should redirect_to :action => "show", id: Ol.first.to_param
    
    ol = Ol.find(ol.id)
    ol.items.should == new_items
  end

  it "should get improve for ol" do
    ol = FactoryGirl.create(:ol_with_user)
    u = FactoryGirl.create(:user)
    sign_in :user, u

    u.add_record(ol, marked)
    
    OlsController.any_instance.should_receive(:get_improvement_data).and_return(quiz_data)
    
    get :improve, id: ol.to_param

    response.should be_success
    response.should render_template(:test)
    assigns(:data).should_not be_nil
    assigns(:post_url).should_not be_nil
  end
  
  it "should display revision data" do
    ol = FactoryGirl.create(:ol_with_user)
    
    # Should fail without a logged-in user
    get :revise, id: ol.to_param
    response.should redirect_to new_user_session_path
    
    # Should work with logged in user
    u = FactoryGirl.create(:user)
    sign_in :user, u

    u.add_record(ol, marked )
    
    OlsController.any_instance.should_receive(:get_improvement_data).and_return(quiz_data)
    get :revise, id: ol.to_param
    
    response.should be_success
    response.should render_template(:display)
    assigns(:data).should_not be_nil
    assigns(:test_url).should_not be_nil
  end
  
  def quiz_data
    {'1' => '2', '3' => '4'}
  end
  
  def marked
    {right: {'1' => 'b'}, wrong: {'2' => 'd'}}
  end
end