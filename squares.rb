require 'ruby2d'

set title: 'Squares'

i = 0

while i < 10 do
	Square.new(x: (i*10), y: 100, size: 8, color: 'white')
	i += 1
end

show