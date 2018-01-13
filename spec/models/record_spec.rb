require 'spec_helper'

describe Record do
  it { should be_referenced_in :user }
  it { should validate_presence_of :user}
  
  it { should be_referenced_in :quiz }
  it { should validate_presence_of :quiz}
  
  it { should embed_many :tries}
  it { should validate_presence_of :tries}
  it { should validate_length_of(:tries).with_minimum(1)}
  it { should validate_uniqueness_of(:quiz_id).scoped_to(:user_id)}

  it 'should create a try' do
    r = Hash[[['3','4'],['1','5']]]
    w = Hash[[['a','b'],['c','d']]]
    rec = Record.new
    rec.create_try(r,w)
    rec.tries[0].right.should == r
    rec.tries[0].wrong.should == w
    
    returned = rec.get_last_imperfect_try
    returned.right.should == r
    returned.wrong.should == w
  end
end

