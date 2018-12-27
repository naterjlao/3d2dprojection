require 'ruby2d'
require_relative '../trig.rb'

set fps: 60
radius = 100
degree = 0
center_x = (get :width)/2
center_y = (get :height)/2

#Text.new(x: 0, y: 0, text: "FPS: ", size: 20, color: 'white')

update do
	clear
	Quad.new(
		x1: sin(degree)*radius+center_x, y1: cos(degree)*radius+center_y,
		x2: sin(degree+90)*radius+center_x, y2: cos(degree+90)*radius+center_y,
		x3: sin(degree+180)*radius+center_x, y3: cos(degree+180)*radius+center_y,
		x4: sin(degree+270)*radius+center_x, y4: cos(degree+270)*radius+center_y,
		color: "white")
	degree += 1
	if degree >= 360 then degree = 0 end
end

show
