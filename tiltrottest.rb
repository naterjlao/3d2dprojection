require_relative 'shapes3d.rb'

space = Space3d.new(r:20,t:20)
cube = Cube3d.new(space:space)

update do
	clear
	Axis3d.new(space:space)
	cube.draw()
	cube.rotate(x_rot:1,y_rot:0,z_rot:1)
	space.r += 1
	#cube.rotateX(x_rot:1)
	#cube.rotateZ()
	#cube.moveX(x:1)
end

show