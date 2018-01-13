class Try
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Store a hash of the right and wrong guesses in the try.
  field :right, :type => Hash
  field :wrong, :type => Hash
  
  validates_length_of :right, :wrong, :allow_nil => false, :minimum => 0
  
  # This just returns the wrong guesses if there were any, otherwise returns the right guesses
  def get_testable_data
    wrong.length > 0 ? wrong : right
  end
end