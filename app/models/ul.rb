require 'quiz'

class Ul < Quiz
  validates_presence_of :items
  validates_length_of :items, :within => 2..1000
    
  private
  field :items, :type => Array  
  
  public
  def mark (attempt)
    right = Array.new
    wrong = Array.new

    if !!attempt
      items_copy = Array.new(items)
      
      attempt.values.each do |value|
        value.strip!
        
        next if value.length == 0
        
        index = nil
        
        items_copy.each_index do |ind| 
          if soft_equal(value, items_copy[ind])
            index = ind
            break
          end
        end
        
        if index
          right.push value.to_s[0..200]
          items_copy.delete_at(index)
        else
          wrong.push value.to_s[0..200]
        end

      end
    end
    
    {right: right, wrong: wrong}
  end
  
  def get_data(min_value, max_value)
    return items[min_value,1 + max_value - min_value].shuffle;
  end
end