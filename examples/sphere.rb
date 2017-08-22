require_relative '../ruby3d.rb'

space = Space3d.new(r:45,t:45)

update do
	clear
	i = 0
	while i < 5 do 
		Circle3d.new(z:10 * i,space:space,resolution:16).draw()
		i += 1
	end
	space.t += 1
	space.r += 1
end

show