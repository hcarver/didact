require 'spec_helper'

describe Metric do
  it 'should log without user' do
    Metric.log(nil, 'a', 'b')
    test nil, 'a', 'b'
  end
  
  it 'should log with user' do
    u = Factory.create(:user)
    
    Metric.log(u, 'a', 'b')
    test u.email, 'a', 'b'    
  end
  
  def test email, type, action
    Metric.first.user.should == email
    Metric.first.type.should == type
    Metric.first.action.should == action
    Metric.first.persisted?.should be_true
  end
end

