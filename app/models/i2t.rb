require 'quiz'

class Item
  include Mongoid::Document
  embedded_in :i2t
  
  mount_uploader :image, ImageUploader
  field :answer
  
  validates_presence_of :image
  validates_size_of :image, maximum: 20.megabytes
  
  validates_presence_of :answer
  validates_length_of :answer, in: 1..200
end

class I2t < Quiz
  validates_length_of :items, :within => 2..1000, message: "must have at least 2 items"
  
  embeds_many :items, cascade_callbacks: true
  accepts_nested_attributes_for :items
  
  public
  def mark (attempt)
    right = Hash.new
    wrong = Hash.new

    if !!attempt
      # Get rid of any spurious keys in the input hash.
      attempt.keep_if { |key,value| key.to_i.between?(0, items.length - 1)  }
    
      attempt.each do |key, value|
        key = key.to_i
        value.strip!
    
        if soft_equal(value, items[key].answer)
          right[key.to_s] = value.to_s[0..200]
        else
          wrong[key.to_s] = value.to_s[0..200]
        end
      end
    end
    
    {right: right, wrong: wrong}
  end
  
  def get_data(min_value, max_value)
    ret = Hash[(min_value..max_value).map{|i| [i.to_s, [items[i].image.url, items[i].answer]]}]
    Hash[ret.to_a.shuffle]
  end
end
