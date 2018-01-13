include QuizHelper

class QuizController < ApplicationController
  before_filter :get_item, :only => [:show, :learn, :quiz, :quizall, :testall, 
    :edit, :update, :improve, :revise, :quizimprove ]
  before_filter :filter_for_owner, :except => [:index, :show, :new, :create, :learn, :quiz, :quizall, :testall, :improve, :revise, :quizimprove]
  before_filter :authenticate_user!, :only => [:new, :create, :improve, :revise]
  before_filter :filter_for_improvable, :only => [:improve, :revise]
  
  def new
    Metric.log(current_user, get_class, 'Create')
    @item = get_class.new
    respond_to do |format|
      format.html {render layout: 'application'} # new.html.erb
    end
  end

  def show
    Metric.log(current_user, @item.name, 'Show')
    @data = @item.get_all_data
    respond_to do |format|
      format.html {render layout: 'application'} # show.html.erb
      format.json { render json: @item }
    end
  end
  
  def index
    Metric.log(current_user, get_class, 'Index')
    @items = get_class.all

    respond_to do |format|
      format.html { render layout: 'application'} # index.html.erb
      format.json { render json: @items }
    end
  end
  
  def testall
    Metric.log(current_user, @item.name, 'Testall')
    @data = @item.get_all_data
    
    @post_url = url_for(:id => @item, :method=>:put, 
      :action => :quizall)
    
    respond_to do |format|
      format.html { render :action=>'test', layout: 'application' }
      format.json { render :action=>'test', json:@item }
    end
  end
  
  def quizall
    Metric.log(current_user, @item.name, 'Quizall')
    if not params[:ans].nil?
      session[@item.id] = params[:ans]
      
      # Save from the session
      if user_signed_in?
        if not current_user.add_record(@item, session[@item.id])
          flash[:notice] = 'Couldn\'t save, sorry.'
        end
      end
    end
    
    @data = @item.get_all_data
    @results = @item.mark(session[@item.id])

    respond_to do |format|
      format.html { render :action=>'full_results', layout: 'application' }
    end
  end
  
  def quizimprove
    Metric.log(current_user, @item.name, 'Quizimprove')
    
    @data = get_improvement_data
    @results = @item.mark(params[:ans])

    session[@item.id] = params[:ans]
    
    if user_signed_in?
      if not current_user.add_record(@item, @results)
        flash[:notice] = 'Couldn\'t save, sorry.'
      end
    end
    
    respond_to do |format|
      format.html { render :action=>'improve_results', layout: 'application' }
    end
  end
  
  def learn
    Metric.log(current_user, @item.name, 'Learn')
    page = (params[:page]  || 0).to_i
    
    chunk_num = page / 3
    @data = @item.get_chunk_data(chunk_num)
    
    if page % 3 == 0
      @test_url = url_for(:page => (page + 1)) 
      
      respond_to do |format|
        format.html { render :action=>'display', layout: 'application'}
      end
    elsif page % 3 == 1
      @post_url = url_for(:method=>:put, :action => :quiz, :page => page)
    
      respond_to do |format|
        format.html { render :action=>'test', layout: 'application' }
      end
    else
      @results = @item.mark(session[@item.id])
      @retry_url = url_for(:page => (page - 1))
      @progress_url = (chunk_num + 1 == @item.get_chunk_count) ?
        url_for(@item) :
        url_for(:page => (page + 1)) 
      respond_to do |format|
        format.html { render :action=>'spottest_results', layout: 'application' }
      end
    end
  end
 
  def quiz
    Metric.log(current_user, @item.name, 'Quiz')
    page = (params[:page] || '0').to_i
    page = [page, 0].max
    
    chunk_num = page / 3
        
    if not params[:ans].nil?
      input = params[:ans]
      
      if session[@item.id].nil?
        session[@item.id] = input
      else
        session[@item.id].merge!(input)
      end

      # Save from the session, and empty it.
      if user_signed_in? and (chunk_num + 1) == @item.get_chunk_count
        if not current_user.add_record(@item, @item.mark(session[@item.id]))
          flash[:notice] = 'Could not save, sorry.'
        end
      end
    end
    
    redirect_to :action => "learn", :page => page + 1
  end
  
  def edit
    Metric.log(current_user, @item.name, 'Edit')
    @data = @item.get_all_data
    
    render layout: 'application'
  end

  def create
    @item = get_class.new()
    item_update(@item, params)
    @item.owner = current_user
    
    Metric.log(current_user, @item.name, 'Create')
    
    if @item.save
      respond_to do |format|
        format.html { redirect_to @item, notice: '"' + (@item.name || 'Item') + '" created.' }
        format.json { render json: @item, status: :created, location: @item }
      end
    else
      respond_to do |format|
        format.html { render action: "new", layout: 'application' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    Metric.log(current_user, @item.name, 'Update')
    item_update(@item, params)
    
    if @item.save
      respond_to do |format|
        format.html { redirect_to @item, notice: '"' + @item.name + '" updated.'}
        format.json { head :ok }
      end
      return
    end
    
    respond_to do |format|
      format.html { render action: "edit", layout: 'application', notice: 'Unable to update ' + @item.name }
      format.json { render json: @item.errors, status: :unprocessable_entity }
    end
  end

  def improve
    Metric.log(current_user, @item.name, 'Improve')
    @data = get_improvement_data
    
    @post_url = url_for(:id => @item, :method=>:put, :action => :quizimprove)
    
    respond_to do |format|
      format.html { render :action=>'test', layout: 'application' }
    end
  end

  def revise
    Metric.log(current_user, @item.name, 'Revise')
    @data = get_improvement_data
    @test_url = url_for(:id => @item, :action => :improve)
    
    respond_to do |format|
      format.html { render :action=>'display', layout: 'application' }
    end
  end
  
  def initialize(class_name)
    @class_name = class_name
  end
  
  protected
  
  def filter_for_owner
    if not user_signed_in?
      flash[:notice] = "Please login first"
      redirect_to :action => 'show'
    elsif not can_edit?(@item)
      flash[:notice] = "Only the owner can make changes like that"
      redirect_to :action => 'show'
    end
  end
  
  def filter_for_improvable
    if not user_signed_in?
      flash[:notice] = 'Log in first'
      redirect_to :action => 'quizall'
    elsif not has_history?(@item)
      flash[:notice] = 'Take the test first to get customised quizzes'
      redirect_to :action => 'quizall'
    end
  end
  
  def get_class
    Kernel.const_get(@class_name)
  end
  
  private
  @class_name

  def get_item
    @item = get_class.find_by_slug(params[:id])
    
    if @item.nil?
      flash[:notice] = "Not found, sorry"
      redirect_to :action => 'index'
    end
  end  
end