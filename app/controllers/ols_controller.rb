class OlsController < QuizController
  def initialize
    super('Ol')
  end
  
  def item_update(item, updateParams)
    if(not updateParams[:ol].nil?)
      item.update_attributes(updateParams[:ol])
            
      if(not updateParams[:ol][:items].nil?)
        vals = updateParams[:ol][:items].to_s.split("\n")
        vals.each { |x| x.strip! }
        vals.delete_if { |val| val.length == 0 }
        item.items = vals
      end
    end
  end
  
  def get_improvement_data
    ret = current_user.get_last_imperfect_go(@item)
    
    if ret[:wrong].length == 0 
      then 
      @item.get_all_data 
    else 
      @item.get_all_data
      @item.get_all_data.select{|key, value| ret.wrong.has_key?(key)} 
    end
  end
end