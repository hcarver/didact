require 'spec_helper'
require 'carrierwave/test/matchers'
require 'i2t'

describe Item do
  it {should be_embedded_in :i2t}

  it {should validate_presence_of :image}
  
  it {should validate_presence_of :answer}
  it {should validate_length_of(:answer).within(1..200)}
end

describe I2t do
  it { should embed_many :items}
  it { should validate_length_of(:items).within(2..1000)}
  
  it 'should mark correctly' do
    
  end
  
  it 'should get data correctly' do
    
  end
end

