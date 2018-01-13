require 'spec_helper'

describe Ul do
  it {should validate_presence_of :items}
  it {should validate_length_of(:items).within(2..1000) }
  
  it 'should mark correctly' do
    u = Ul.new
    u.items = ['1','2','2','3']
    
    results = u.mark (
      Hash[[['1','2'],['2','2'],['3','2'],['4','3'],['5','4']]]
    )
    
    results[:right].should == ['2','2','3']
    results[:wrong].should == ['2', '4']
  end
  
  it 'should return its data' do
    u = Ul.new
    u.items = (1..10).to_a
    u.get_data(4,6).sort.should == (5..7).to_a
  end
end

