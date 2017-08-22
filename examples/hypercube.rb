require_relative '../shapes3d.rb'



TILT = 40
NUM_CUBES = 15
SCREEN_SIZE = 600
MAX_SIZE = SCREEN_SIZE * 0.6
MIN_SIZE = 10
SIZE_INC = (MAX_SIZE - MIN_SIZE) / NUM_CUBES
MIN_SPEED = -1
SPEED_INC = 0.3
COLORS = ['red','orange','yellow','green','blue','purple']

set width: SCREEN_SIZE
set height: SCREEN_SIZE
set title: 'Hypercube'
cubes = Array.new(NUM_CUBES) {Space3d.new(t:TILT,x_dim:(get :width),y_dim:(get :height))}

update do
	clear
	i = 0
	while i < NUM_CUBES do
		Cube3d.new(
			space:cubes[i],
			size: MIN_SIZE + i*SIZE_INC,
			color:COLORS[i % COLORS.size],
			width: 2
		).draw()
		cubes[i].r += i * SPEED_INC + MIN_SPEED
		cubes[i].t += 1
		if cubes[i].t > 360 then cubes[i].t = 0 end 
		i += 1
	end
end

show