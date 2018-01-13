require 'spec_helper'

describe Try do
  it {should validate_length_of(:right).with_minimum(0)}
  it {should validate_length_of(:wrong).with_minimum(0)}
  
  it 'should get testable data' do
    t = Try.new
    data = {'a' => 'b'}
    right_data = {'c' => 'd'}
    t.wrong = data
    t.right = right_data
    
    t.get_testable_data.should == data
    
    t.wrong = {}
    t.get_testable_data.should == right_data
  end
end

