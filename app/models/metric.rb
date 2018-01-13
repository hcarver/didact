require 'devise'

class Metric
  include Mongoid::Document
  
  field :user, :type => String
  field :date, :type => DateTime
  field :type, :type => String
  field :action, :type => String

  def Metric.log(user, type, action)
    metric = Metric.new
    metric.user = !!user ? user.email : nil
    metric.date = Time.now
    metric.type = type
    metric.action = action
    metric.save
  end
end