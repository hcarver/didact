class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, 
    :omniauthable
  
  ## Database authenticatable
  field :email,              :type => String, :null => false
  field :encrypted_password, :type => String, :null => false

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String
  
  field :name, type: String
  
  # Use setter method to ensure the name and email values have no
  # leading / trailing spaces.
  def name=(value)
    write_attribute(:name, value.strip)
  end
  
  def email=(value)
    write_attribute(:email, value.strip.downcase)
  end
  
  has_many :ols, inverse_of: :owner
  has_many :uls, inverse_of: :owner
  has_many :t2ts, inverse_of: :owner
  has_many :i2ts, inverse_of: :owner
  
  has_many :records, dependent: :delete
  
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  validates_length_of :name, minimum: 4, maximum: 60
  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :name, :without => /.*admin.*/i
  validates_format_of :name, without: /.*pogohop.*/i
  validates_format_of :name, without: /.*root.*/i

  def self.find_for_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.where(:email => data.email).first
      Metric.log(user, 'OAuth login', 'Repeat')
      user
    else # Create a user with a stub password. 
      user = User.create!(:name => 'anonymous', :email => data.email.downcase, :password => Devise.friendly_token[0,20]) 
      Metric.log(user, 'OAuth login', 'First time')
      user
    end
  end
  
  def self.find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info
    if user = User.where(:email => data["email"].downcase).first
      Metric.log(user, 'OpenId login', 'Repeat')
      user
    else
      user = User.create!(:name => 'anonymous', :email => data["email"], :password => Devise.friendly_token[0,20])
      Metric.log(user, 'OpenId login', 'First time')
      user
    end
  end

  def add_record(item, go)
    record = records.find_or_initialize_by(quiz_id: item.id)
    record.create_try(go[:right], go[:wrong])
    record.save
  end
  
  def get_last_imperfect_go(item)
    record = records.where(quiz_id: item.id).first
    if not record.nil? then record.get_last_imperfect_try else nil end
  end
  
  def has_history?(item)
    not records.where(quiz_id: item.id).empty?
  end

  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if
      params[:password_confirmation].blank?
    end

    update_attributes(params)
  end 
end

Warden::Manager.after_set_user do |user, auth, opts|
  Metric.log(user, 'Login', nil)
end
