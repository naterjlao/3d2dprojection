require 'ruby2d'
require_relative '../shapes2d.rb'

#test
set width: 1000
set height: 1000
angle = 0
length = 0
inc = true

maxLength = 300
speed = Random.rand(1..10)

update do

	x2 = Math.sin((angle*Math::PI)/180)*length+500
	y2 = Math.cos((angle*Math::PI)/180)*length+500
	Dot2d.new(x:x2,y:y2)

	STDOUT.write "Speed: #{speed} FPS: #{get :fps}\r"

	angle += 1
	if angle >= 360 then angle = 0 end
	if inc then length += speed else length -= speed end
	if length > maxLength then inc = false elsif length <= 0 then inc = true end
end

show