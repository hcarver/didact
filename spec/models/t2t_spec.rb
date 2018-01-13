require 'spec_helper'

describe T2t do
  it {should validate_presence_of :items}
  it {should validate_length_of(:items).within(2..1000)}
  
  it 'should mark correctly' do
    t = T2t.new
    t.items = {'a' => 'b', 'c' => 'd'}
    result = t.mark ({'a'=>'b', 'c' => 'e', 'f' => 'g'})
    result[:right].should == {'a' => 'b'}
    result[:wrong].should == {'c' => 'e'}
  end
  
  it 'should get data' do
    t = T2t.new
    t.items = Hash[[['1', '2'], ['3', '4'], ['5', '6'], ['7', '8']]]
    t.get_data(1,2).should == {'3' => '4', '5' => '6'}
  end
end

