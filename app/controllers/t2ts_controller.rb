class T2tsController < QuizController
  def initialize
    super('T2t')
  end
  
  def item_update(item, updateParams)
    unless updateParams[:t2t].nil?
      item.update_attributes(updateParams[:t2t])
       
      input_items = Hash.new
      
      unless updateParams[:t2t][:items].nil?
        updateParams[:t2t][:items].to_s.split("\n").each do |line|
          (k,v) = line.split(":", 2)
          input_items[k.strip] = !v ? "" : v.strip
          input_items.delete_if { |k,v| k.length == 0 }
        end
      end
      
      item.items = input_items
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