require_relative '../shapes3d.rb'
require_relative '../projection.rb'

set height: 800
set width: 800

space = Space3d.new(r:20,t:20,x_dim:(get :width),y_dim:(get :height))
cube = Cube3d.new(size:200,space:space)
axis = Axis3d.new(space:space)
axisoffset = Axis3d.new(origin:Vector[1,1,1],space:space)

tick = 0
speed = 0
acc = true
update do
	clear
	cube.draw()
	axis.draw()
	cube.rotate(x_rot:0,y_rot:0,z_rot:speed)
	space.r += 1

	if tick % 60 == 0 then
		if acc then
			speed += 1
		else
			speed -= 1
		end
		acc = true if speed < -5
		acc = false if speed > 5
	end

	tick += 1

	STDOUT.write "x_rot: #{cube.x_rot} y_rot: #{cube.y_rot} z_rot: #{cube.z_rot}\r"
end

show