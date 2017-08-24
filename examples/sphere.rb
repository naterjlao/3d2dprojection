require_relative '../ruby3d.rb'

space = Space3d.new(r:45,t:45)
sphere = Sphere3d.new(space:space)

update do
	sphere.draw()
	space.r += 1
end

show