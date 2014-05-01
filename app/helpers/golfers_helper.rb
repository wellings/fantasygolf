module GolfersHelper

  def resource_name
    :golfer
  end

  def resource
    @resource ||= Golfer.new
  end
end
