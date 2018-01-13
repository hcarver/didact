require 'quiz'

class T2t < Quiz
  validates_presence_of :items
  validates_length_of :items, :within => 2..1000
    
  private
  field :items, :type => Hash  
  
  public
  def mark (attempt)
    right = Hash.new
    wrong = Hash.new

    if !!attempt
      # Get rid of any spurious keys in the input hash.
      attempt.keep_if { |key,value| items.has_key?(key) }
    
      attempt.each do |key, value|
        value.strip!
        
        next if value.length == 0
        
        if soft_equal(value, items[key])
          right[key] = value.to_s[0..200]
        else
          wrong[key] = value.to_s[0..200]
        end
      end
    end
    
    {right: right, wrong: wrong}
  end
  
  def get_data(min_value, max_value)
    key_list = items.keys.slice(min_value, 1 + max_value - min_value)
    ret = items.select { |key,value| key_list.include?(key) }
    Hash[ret.to_a.shuffle]
  end
end
