require_relative '../shapes3d.rb'
require_relative '../projection.rb'

set height: 800
set width: 800

space = Space3d.new(r:20,t:20,x_dim:(get :width),y_dim:(get :height))
cube = Cube3d.new(space:space)
axis = Axis3d.new(space:space)
axisoffset = Axis3d.new(origin:Vector[1,1,1],space:space)


update do
	clear
	cube.draw()
	axis.draw()
	cube.rotate(x_rot:1,y_rot:0,z_rot:1)
	space.r += 1
end

show