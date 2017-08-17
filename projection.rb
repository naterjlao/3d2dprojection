=begin

transformation matrix:

[	cos(r) 			sin(r) 			0
 	sin(r)*sin(t)	cos(r)*sin(t)	cos(t)	]
=end

require 'matrix'
require_relative 'shapes2d.rb'
require_relative '../math_util/trig.rb'

=begin
	Returns a Matrix that represents the projection of 3D space 'points' to 
	a 2D space. 'r' represents the orbital rotation of the 3D objects and 't'
	represents the tilt of the 3D objects away from the z axis. It is assumed 
	that 'r' and 't' are in degrees unless 'degrees' are set to false.
=end
def project(points:,space:)
	# Check if points is a matrix or a vector that has a row dimension of 3
	if (points.class != Matrix && points.class != Vector) || 
		(points.class == Matrix && points.row_size != 3) ||
		(points.class == Vector && points.size != 3)then
		return false
	end

	# Covert the r and t values into radians
	if space.degrees then 
		r = degToRads(space.r)
		t = degToRads(space.t)
	else
		r = space.r
		t = space.t
	end

	# Transformation Matrix
	transform = Matrix[
		[Math.cos(r), Math.sin(r), 0],
		[-Math.cos(r+Math::PI/2)*Math.sin(t), -Math.sin(r+Math::PI/2)*Math.sin(t), -Math.cos(t)]
	]

	return transform * points
end

=begin
	Draws a series of lines based off the coordinate Matrix of 'points'. 
	If there are 
=end
def draw2d(points:,color:'white',space:)
	if (points.class == Matrix || points.class = Vector) && 
		((points.class == Matrix && points.row_size == 2 && points.column_size > 0) || 
		(points.class == Vector && points.size == 2))  then
		
		col_size = points.column_size
		col = 0
		
		# Connect the dots
		if col_size > 1 then
			while (col + 1) < col_size do
				Line2d.new(
					x1:points[0,col]+space.x,y1:points[1,col]+space.y,
					x2:points[0,col+1]+space.x,y2:points[1,col+1]+space.y,
					color:color)
				col += 1
			end
		else # draw a dot
			x = points[0,0]
			y = points[1,0]
		end
	end
end

def draw3d(points:,color:'white',space:)
	projection = project(points:points,space:space)
	draw2d(points:projection,color:color,space:space)
end
