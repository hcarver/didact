module ApplicationHelper
  def link_or_text(condition, text, url, hint)
    if condition
      link_to text, url
    else
      content_tag(:span, text, :class => 'pseudolink', :title=>hint)
    end
  end
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association, parent)
    new_object = f.object.class.reflect_on_association(association).klass.new

    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
  
    link_to_function(name, "add_fields(\"#{parent}\", \"#{association}\", \"#{escape_javascript(fields)}\")")
  end
end
