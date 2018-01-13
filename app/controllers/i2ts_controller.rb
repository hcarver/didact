class I2tsController < QuizController
  def initialize
    super('I2t')
  end
  
  def item_update(item, updateParams)
    # TODO AT SOME POINT, probably need to call remove_image or remove_photo or something    
    i2t_data = updateParams[:i2t]
    
    unless i2t_data.nil?
      item.update_attributes(i2t_data)
      
      item.name = i2t_data[:name]
      
      photo_data = i2t_data[:items_attributes]
      
      unless photo_data.nil?
        photo_data.each do |key, value|
         
          image = value[:image]
          answer = value[:answer]
          
          unless image.nil? and (answer.nil? or answer.length == 0)
            item.items.push(Item.new({image: image, answer: answer.to_s.strip}))
          end
        end
      end
    end
  end
  
  def get_improvement_data
    ret = current_user.get_last_imperfect_go(@item)
    
    if ret[:wrong].length == 0 
      then 
      @item.get_all_data 
    else 
      @item.get_all_data.select{|key, value| ret.wrong.has_key?(key)} 
    end
  end
end