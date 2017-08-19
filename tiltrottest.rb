require_relative 'shapes3d.rb'
require_relative 'projection.rb'

space = Space3d.new(r:20,t:20)
cube = Cube3d.new(space:space)
axis = Axis3d.new(space:space)
axisoffset = Axis3d.new(origin:Vector[1,1,1],space:space)


update do
	clear
	cube.draw()
	axis.draw()
	cube.rotate(x_rot:1,y_rot:0,z_rot:1)
	draw3d(points:Matrix.columns([[0,0,0],[100,100,100]]),space:space)
	space.r += 1
	#cube.rotateX(x_rot:1)
	#cube.rotateZ()
	#cube.moveX(x:1)
end

show