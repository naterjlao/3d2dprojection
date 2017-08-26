require_relative '../ruby3d.rb'

space = Space3d.new(r:45,t:15)
sphere = Sphere3d.new(x:50,y:50,z:50,space:space,resolution:10,size:200)
axis = Axis3d.new(space:space)

update do
	clear
	sphere.draw()
	sphere.drawAxis()
	axis.draw()
	sphere.moveX(5)
end

show