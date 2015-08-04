class SClass < ActiveRecord::Base
  belongs_to :user

  searchable do
    text :course_code, :default_boost => 2
    text :Title
  end

  def updateSchedule

  end



end
