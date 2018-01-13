require 'spec_helper'

describe Ol do
  it { should validate_presence_of(:items) }
  it { should validate_length_of(:items).within(2..1000) }

  it 'Should mark things properly' do
    ol = FactoryGirl.create(:ol_with_user)
    marked = ol.mark({'1' => '1', '2' => '3'})
    marked[:right].should == {'1' => '1'}
    marked[:wrong].should == {'2' => '3'}
  end
  
  it 'Should get data' do
    ol = Ol.new
    ol.items = (0..100).to_a.map { |item| item.to_s}
    ans = ol.get_data(3, 5)
    # The keys are 1-indexed in the return.
    ans.should == {'4' => '3', '5' => '4', '6' => '5'}
  end
end
