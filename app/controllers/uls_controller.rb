class UlsController < QuizController
  def initialize
    super('Ul')
  end
  
  def item_update(item, updateParams)
    if(not updateParams[:ul].nil?)
      item.update_attributes(updateParams[:ul])
      
      if(not updateParams[:ul][:items].nil?)      
        vals = updateParams[:ul][:items].to_s.lines.to_a
        vals.each { |x| x.strip! }
        vals.delete_if { |val| val.length == 0 }
        
        item.items = vals
      end
    end
  end
  
  def get_improvement_data
    last_try = current_user.get_last_imperfect_go(@item)
   
    if last_try.right.length == @item.items.length
      then @item.get_all_data
    else
      @item.items.select{|value| not last_try.right.include?(value)}
    end
  end
end
