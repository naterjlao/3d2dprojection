require_relative '../ruby3d.rb'

space = Space3d.new(r:45,t:15)
sphere = Sphere3d.new(space:space,resolution:10,size:200)

update do
	clear
	sphere.draw()
	space.r += 1
	space.t += 1
end

show