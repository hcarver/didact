require 'spec_helper'

describe Quiz do
  it { should validate_presence_of(:name)}
  it { should validate_length_of(:name).within(4..60)}
  
  it { should validate_presence_of(:owner) }
  
  it { should reference_many(:records) }
  
  it 'should return all data' do
    array = (1..10).to_a
    quiz = Ol.new
    quiz.items = array
    quiz.get_all_data.length.should == 10
  end
  
  it 'should get block counts correctly' do
    expectedCounts = {2=>[2],
      3=>[3],
      4=>[4],
      5=>[3,2],
      6=>[3,3],
      7=>[4,3],
      8=>[4,4],
      9=>[4,3,2],
      10=>[4,3,3],
      11=>[4,4,3],
      12=>[4,4,4]    }

    # Use OL to get a quiz type with items.
    quiz = Ol.new
    
    expectedCounts.keys.each do |count|
      quiz.items = 1.upto(count).to_a
      
      quiz.get_chunk_count.should equal expectedCounts[count].length
      
      countSoFar = 1
      0.upto(quiz.get_chunk_count - 1) do |chunkNum|
        quiz.get_chunk_data(chunkNum).keys.first.to_i.should == countSoFar
        quiz.get_chunk_data(chunkNum).keys.last.to_i.should == (countSoFar + expectedCounts[count][chunkNum] - 1)
        
        countSoFar += expectedCounts[count][chunkNum]
      end
    end    
  end
end

