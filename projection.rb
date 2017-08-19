require 'matrix'
require_relative 'shapes2d.rb'
require_relative 'matrixtransformations.rb'
require_relative '../math_util/trig.rb'

=begin
	Represents the visual perspective of 3D space. The angle 'r' represents the orbital 
	rotation of the axis and 't' represents the tilt away from the z axis. The 'degrees'
	boolean represents if the value of the 'r' and 't' are in degrees. 'x_disp' and 'y_disp' 
	are positional displacement of the 2 dimensional projection. 'x_dim' and 'y_dim' are
	dimensions of the output screen: :width and :height respectively. (They can be accessed
	by calling 'set height: {some_number}' or 'get :height')
=end
class Space3d
	attr_accessor :r,:t,:degrees,:x_disp,:y_disp,:x_dim,:y_dim

	def initialize(r:0,t:0,degrees:true,x_disp:-1,y_disp:-1,x_dim:640,y_dim:480)
		@r = r
		@t = t
		@degrees = degrees

		# If displacement is not given, then it is calculated by the given x
		# and y dimensions
		if x_disp > -1 then
			@x_disp = x_disp
		else
			@x_disp = x_dim/2
		end
		if y_disp > -1 then
			@y_disp = y_disp
		else
			@y_disp = y_dim/2
		end
	end


	# Returns a Matrix that represents the projection of 3D space 'points' to 
	# a 2D space. 'r' represents the orbital rotation of the 3D objects and 't'
	# represents the tilt of the 3D objects away from the z axis. It is assumed 
	# that 'r' and 't' are in degrees unless 'degrees' are set to false.
	def project(points:)
		# Check if points is a matrix or a vector that has a row dimension of 3
		if (points.class != Matrix && points.class != Vector) || 
			(points.class == Matrix && points.row_size != 3) ||
			(points.class == Vector && points.size != 3)then
			return false
		end

		# Covert the r and t values into radians
		if @degrees then 
			r = degToRads(@r)
			t = degToRads(@t)
		else
			r = @r
			t = @t
		end

		# Transformation Matrix
		transform = ProjectionMatrix.project3d2d(r,t)

		return transform * points
	end


	# Draws a series of lines based off the coordinate Matrix or Vector of 'points'. 
	# If there are only one point in the Matrix, a dot is drawn at that singular point.
	# Note that the origin is centered on the display screen, this is based
	def draw2d(points:,color:'white',size:1)
		if (points.class == Matrix && points.row_size == 2 && points.column_size > 0) || 
			(points.class == Vector && points.size == 2) then
			col_size = 1
			col_size = points.column_size if points.class == Matrix 
			col = 0

			# Connect the dots
			if col_size > 1 then
				while (col + 1) < col_size do
					# Generate Lines (note that y is subtractive since 
					# the positive direction goes 'down')
					Line2d.new(
						x1:@x_disp + points[0,col],
						y1:@y_disp - points[1,col],
						x2:@x_disp + points[0,col + 1],
						y2:@y_disp - points[1,col + 1],
						color:color,width:size)
					col += 1
				end
			else # Else, draw a dot
				x = @x_disp
				y = @y_disp
				if points.class == Matrix then
					x += points[0,0]
					y -= points[1,0]
				else
					x += points[0] 
					y -= points[1] 
				end
				Dot2d.new(x:x,y:y,color:color,size:size)
			end
		end
	end

	def draw3d(points:,color:'white')
		projection = project(points:points)
		draw2d(points:projection,color:color)
	end
end


