module QuizHelper
  def can_edit? (item)
    if user_signed_in? and !!item and  item.owner.id == current_user.id
      true
    else
      false
    end
  end
  
  def can_create?
    user_signed_in?
  end
  
  def has_history? (item)
    user_signed_in? and 
      current_user.has_history?(item)
  end
end
