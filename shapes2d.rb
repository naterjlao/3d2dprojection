require 'ruby2d'

# Draws a line in 2D space from the vertex (x1,y2) to the vertex (x2,y2)
class Line2d < Quad
	def initialize(x1:,y1:,x2:,y2:,color:'white')	
		@width = 1
		x3 = x2
		y3 = y2
		x4 = x1
		y4 = y1

		if (x1 - x2).abs < (y1 - y2).abs then
			x3 += @width
			x4 += @width
		else
			y3 += @width
			y4 += @width
		end

		super(
		x1:x1,y1:y1,
		x2:x2,y2:y2,
		x3:x3,y3:y3,
		x4:x4,y4:y4,
		color:color)
	end
end

# Draws a point in 2d space at the point (x,y)
class Dot2d < Quad
	def initialize(x:,y:,size:1,color:'white')
		super(
		x1:x,y1:y,
		x2:x+size,y2:y,
		x3:x+size,y3:y+size,
		x4:x,y4:y+size,
		color:color)
	end
end






