require 'quiz'

class Ol < Quiz
  validates_presence_of :items
  validates_length_of :items, :within => 2..1000
  
  private
  field :items, :type => Array  
  
  public
  def mark (attempt)
    right = Hash.new
    wrong = Hash.new

    if !!attempt
      attempt.delete_if { |key,value| not key.to_i.between?(1, items.length) }
    
      attempt.keys.each do |key|
        attempt[key].strip!
        
        if soft_equal(attempt[key], items[key.to_i - 1])
          right[key] = attempt[key].to_s[0..200]
        else
          wrong[key] = attempt[key].to_s[0..200]
        end
      end
    end
    
    {right: right, wrong: wrong}
  end
  
  def get_data(min_value, max_value)
    data = Hash.new
    min_value.upto(max_value) do |number|
      data[(number + 1).to_s] = items[number]
    end
    
    return data
  end
end
