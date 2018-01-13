require 'spec_helper'

describe User do
  it { should reference_many(:records) }

  it { should reference_many(:ols) }
  it { should reference_many(:uls) }
  it { should reference_many(:t2ts) }
  it { should reference_many(:i2ts) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:password) }

  it { should validate_uniqueness_of(:email) }
  it { should validate_length_of(:name).within(4..60) }
  it { should validate_format_of(:name).not_to_allow("admin").not_to_allow("pogohop").not_to_allow("root") }
  it { should validate_format_of(:email).to_allow('valid@email.address').not_to_allow('invalid email')}
  it 'should find OAuth users' do
    u1 = User.find_for_oauth(OmniAuth.config.mock_auth[:google])
    u1.persisted?.should be_true
    
    u2 = User.find_for_oauth(OmniAuth.config.mock_auth[:google])
    u2.id.should == u1.id
  end
  
  it 'should find OpenId users' do
    u1 = User.find_for_open_id(OmniAuth.config.mock_auth[:facebook])
    u1.persisted?.should be_true
    
    u2 = User.find_for_open_id(OmniAuth.config.mock_auth[:facebook])
    u2.id.should == u1.id
  end
  
  it 'should strip name whitespace' do
    u = FactoryGirl.create(:user)
    u.name = '    some name    '
    u.name.should == 'some name'
  end
  
  it 'should strip email whitespace' do
    u = FactoryGirl.create(:user)
    u.email = '   user@example.com   '
    u.email.should == 'user@example.com'
  end

  it 'should add records' do
    testHash = {
      right: {'key' => 'value'},
      wrong: {'wrong' => 'wronger'}
    }
    ol = FactoryGirl.create(:ol_with_user)
    ol.save

    u = User.first
    u.has_history?(ol).should be_false
    
    u.add_record(ol, testHash)
      
    u.has_history?(ol).should be_true
    u.get_last_imperfect_go(ol).right.should == testHash[:right]
    u.get_last_imperfect_go(ol).wrong.should == testHash[:wrong]
  end
end