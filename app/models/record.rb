class Record
  include Mongoid::Document
  
  # Note that it's necessary to use referenced_in rather than the normal Mongoid macros
  # because the relationship is only defined in this one direction. This is because you can't 
  # have reference relationships to documents embedded in other documents in Mongoid.
  belongs_to :user
  belongs_to :quiz
  
  embeds_many :tries
  
  validates_presence_of :tries, :quiz, :user
  validates_length_of :tries, minimum: 1
  validates_uniqueness_of :quiz_id, :scope => [:user_id]
  
  def create_try (right, wrong)
    tries.new(right: right, wrong: wrong)
  end
  
  def get_last_imperfect_try
    ret = tries.select {|try| try.wrong.length > 0}.last

    if ret.nil?
      ret = tries.last
    end
    
    return ret
  end
end