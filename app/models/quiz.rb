# Deriving classes must
#  * have an accessible variable called items
#  * implement a method called get_data(first index, last index)
#  * implement a method called mark(data_as_hash)

class Quiz
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Slug
  
  field :name, :type => String
  
  belongs_to :owner, class_name: 'User'
  has_many :records, dependent: :delete
  
  attr_accessible :name
  
  slug :name
  
  validates_presence_of :name, :owner
  validates_length_of :name, :minimum => 4, :maximum => 60
    
  public
  def get_chunk_count
    # We don't want chunks bigger than 4, but we also want to avoid chunks of 1.
    length = items.length
    
    return 1 if length < 5
    
    case (length % 4)
    when 0
      length / 4
    else
      length / 4 + 1
    end
  end
  
  def get_all_data
    return get_data(0, items.length - 1)
  end
  
  def get_chunk_data(chunk)
    return get_data(first_of_chunk(chunk), last_of_chunk(chunk))
  end

  def soft_equal(str1, str2)
    str1.squeeze(" ").casecmp(str2.squeeze(" ")) == 0
  end
  
  private
  def first_of_chunk(chunk_num)
    # If not the last
    if(chunk_num < (get_chunk_count - 1))
      return 4 * chunk_num
    end

    length = items.length
        
    # If short enough
    if length < 5
      return 0
    end
    
    # Otherwise
    case (length % 4)
    when 0
      4 * chunk_num
    when  1
      # End with a 3 and a 2
      4 * chunk_num - 1
    when 2
      # End with a 3 and a 3
      4 * chunk_num - 1
    when 3
      # End with a 4 and a 3
      4 * chunk_num
    end
  end
  
  def last_of_chunk(chunk_num)
    length = items.length
    count = get_chunk_count()
    
    if length < 5
      return length - 1
    end
    
    if(chunk_num == count - 1)
      return length - 1
    elsif (chunk_num < count - 2)
      return 4 * (chunk_num) + 3
    end
    
    case (length % 4)
    when 0
      4 * (chunk_num) + 3
    when  1
      # End with a 3 and a 2
      4 * chunk_num + 2
    when 2
      # End with a 3 and a 3
      4 * chunk_num + 2
    when 3
      # End with a 4 and a 3
      4 * (chunk_num) + 3
    end
  end  
end
