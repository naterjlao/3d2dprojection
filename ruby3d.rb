=begin
	A Ruby 3D visualizer based on the ruby2d API. Defined below is the superclass 'Shape3d'.
	An object that is a 'Shape3d' is a 3 dimensional object that exists as a matrix of vectors.
	Manipulation of an object is based on linear transformation via matrix multiplication,
	subtraction and addition.
=end

require_relative 'matrixtransformations.rb'
require_relative 'projection.rb'

=begin
	Superclass of any shape generated in 3D space. Holds values for the
	'x','y','z' position, the local 'x_rot','y_rot','z_rot' rotation, If
	the angle are degrees ('degrees'), the 'size' of the shape, the 'color'
	and the 'space' at which the shape occupies.
=end
class Shape3d
	attr_reader :x,:y,:z # Tracks movement in the xyz direction
	attr_reader :x_rot,:y_rot,:z_rot # Tracks the degrees of local rotations (in degrees)
	attr_accessor :size  # Size of the object
	attr_accessor :width # Width of the lines that form the wireframe of the object
	attr_accessor :color # Color of the object
	attr_accessor :space # Space3d object that represents the space that the object occupies
	@points # 3 Dimensional matrices representing the vectors that makeup the shape
	@basis # A matrix representing the stadard basis of the object:
			# 0 - the x vector, 1 - the y vector, 2 - z vector

	def initialize(x:0,y:0,z:0,size:100,width:1,color:'white',space:)
		@x = x
		@y = y
		@z = z
		@size = size
		@color = color
		@width = width
		@space = space
		@x_rot = @y_rot = @z_rot = 0
		@basis = Matrix.columns([[@x + 1, @y, @z], [@x, @y + 1,@z], [@x, @y, @z + 1]])
	end

	def draw()
		@space.draw3d(points:@points,color:@color,width:@width)
	end

	def drawAxis()
		Axis3d.new(origin:originVector(),axis:@basis,disp:displacementBasisMatrix(4),space:@space).draw()
	end

	# Move Functions:
	# Specifies movement in the x,y,z direction. Note that the values given are
	# not absolute positions in space but rather a displacement of the current
	# position of the object.
	def move(x:0,y:0,z:0)
		moveX(x:x)
		moveY(y:y)
		moveZ(z:z)
	end

	def moveX(x = 0)
		@x += x
		@points = MovementMatrix.moveX3d(x,@points.column_size) + @points
		@basis = MovementMatrix.moveX3d(x,@basis.column_size) + @basis
	end

	def moveY(y = 0)
		@y += y
		@points = MovementMatrix.moveY3d(y,@points.column_size) + @points
		@basis = MovementMatrix.moveY3d(y,@basis.column_size) + @basis
	end

	def moveZ(z = 0)
		@z += z
		@points = MovementMatrix.moveZ3d(z,@points.column_size) + @points
		@basis = MovementMatrix.moveZ3d(z,@basis.column_size) + @basis
	end

	# Rotational Functions (Local):
	# Specifies rotational movement based on the local orientation of the object.
	# Note that all values are a displacement of rotation based on the current
	# position of the object. Local rotational movement is based on the local
	# axis of the object
	def rotate(x_rot:0,y_rot:0,z_rot:0,degrees:true)
		rotateX(x_rot:x_rot,degrees:degrees)
		rotateY(y_rot:y_rot,degrees:degrees)
		rotateZ(z_rot:z_rot,degrees:degrees)
	end

	def rotateX(x_rot = 0, degrees = true)
		# update local rotation value
		if degrees then 
			@x_rot += x_rot
			x_rot = degToRads(x_rot)
		else 
			@x_rot += radsToDeg(x_rot) 
		end

		@x_rot = @x_rot % 360
		disp = displacementMatrix() 				# Displacement matrix
		dispAxis = displacementBasisMatrix()		# Displacement matrix for axis of basis
		rotation = RotationMatrix.rotateX3d(x_rot)	# Rotation transformation matrix

		# Process - place matrix back to origin, apply rotation, place back
		@points = rotation * (@points - disp) + disp
		@basis = rotation * (@basis - dispAxis) + dispAxis
	end

	def rotateY(y_rot = 0, degrees = true)
		if degrees then 
			@y_rot += y_rot
			y_rot = degToRads(y_rot) 
		else
			@y_rot += radsToDeg(y_rot)
		end

		@y_rot = @y_rot % 360
		disp = displacementMatrix()
		dispAxis = displacementBasisMatrix()			
		rotation = RotationMatrix.rotateY3d(y_rot)

		@points = rotation * (@points - disp) + disp
		@basis = rotation * (@basis - dispAxis) + dispAxis
	end

	def rotateZ(z_rot = 0,degrees = true)
		if degrees then 
			@z_rot += z_rot
			z_rot = degToRads(z_rot) 
		else
			@z_rot += radsToDeg(z_rot)
		end

		@z_rot = @z_rot % 360
		disp = displacementMatrix()
		dispAxis = displacementBasisMatrix()			
		rotation = RotationMatrix.rotateZ3d(z_rot)

		@points = rotation * (@points - disp) + disp
		@basis = rotation * (@basis - dispAxis) + dispAxis
	end

	# Rotational Functions (Global):
	# Specifies rotation of the object based on the rotational axis of 3D space.
	# Note that values are a displacement of the original orientation of the
	# object.
	def rotateGlobalX(x_rotg = 0,degrees = true)
	end

	def rotateGlobalY(y_rotg = 0,degrees = true)
	end

	def rotateGlobalZ(z_rotg = 0,degrees = true)
	end


	# Utility Functions:
	# Returns a displacement matrix of the current object (ie. movement in space)
	def displacementMatrix()
		return MovementMatrix.moveX3d(@x,@points.column_size) + 
			MovementMatrix.moveY3d(@y,@points.column_size) +
			MovementMatrix.moveZ3d(@z,@points.column_size)
	end

	def displacementBasisMatrix(cols = 0)
		if cols < 1 then 
			return MovementMatrix.moveX3d(@x,@basis.column_size) + 
				MovementMatrix.moveY3d(@y,@basis.column_size) +
				MovementMatrix.moveZ3d(@z,@basis.column_size)
		else
			return MovementMatrix.moveX3d(@x,cols) + 
				MovementMatrix.moveY3d(@y,cols) +
				MovementMatrix.moveZ3d(@z,cols)
		end
	end

	def originVector()
		return Vector[@x,@y,@z]
	end
end

=begin
	Generates a 3D axis centered at the origin of the 3D vector space.
	Red represents the x axis, Green represents the y axis and Blue represents
	the z axis. 
=end
class Axis3d < Shape3d
	def initialize(
		origin:Vector[0,0,0],
		axis:Matrix.columns([[1,0,0],[0,1,0],[0,0,1]]),
		disp:Matrix.zero(3,axis.column_size + 1),size:50,space:)
		super(size:size,space:space)

		axis = Matrix.columns([origin.to_a, axis.column(0).to_a, axis.column(1).to_a, axis.column(2).to_a])
		@colors = ['red','green','blue']
		@points = size * (axis - disp) + disp
	end

	def draw()
		projection = @space.project(points:@points)
		for i in 1..3 do
			@space.draw2d(
				points:Matrix.columns([projection.column(0),projection.column(i)]),
				color:@colors[i-1])
		end
	end
end

require_relative 'shapes3d.rb'