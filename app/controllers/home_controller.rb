class HomeController < ApplicationController
  def index
    Metric.log(current_user, 'Home page visit', nil)
    ols = Ol.all(sort: [[:updated_at, :desc]]).cache
    uls = Ul.all(sort: [[:updated_at, :desc]]).cache
    t2ts = T2t.all(sort: [[:updated_at, :desc]]).cache
    i2ts = I2t.all(sort: [[:updated_at, :desc]]).cache
    @items = (ols + uls + t2ts + i2ts).shuffle
  end
end
