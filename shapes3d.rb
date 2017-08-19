require 'matrix'
require 'ruby2d'
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
	attr_accessor :color # Color of the object
	attr_accessor :space # Space3d object that represents the space that the object occupies
	@points # 3 Dimensional matrix representing the vectors that makeup the shape
	@origin # A matrix representing the origin of the object:
			# 0 - the origin, 1 - the x vector, 2 - the y vector, 3 - z vector

	def initialize(x:0,y:0,z:0,size:100,color:'white',space:)
		@x = x
		@y = y
		@z = z
		@size = size
		@color = color
		@space = space
		@x_rot = @y_rot = @z_rot = 0
	end

	def draw()
		@space.draw3d(points:@points,color:@color)
	end

	def move(x:0,y:0,z:0)
		moveX(x:x)
		moveY(y:y)
		moveZ(z:z)
	end

	def moveX(x:0)
		transformation = Matrix.build(3,@points.column_size) do |row,col| 
			if row == 0 then x else 0 end 
		end

		@points = transformation + @points
	end

	def moveY(y:0)
		transformation = Matrix.build(3,@points.column_size) do |row,col|
			if row == 1 then y else 0 end
		end

		@points = transformation + @points
	end

	def moveZ(z:0)
		transformation = Matrix.build(3,@points.column_size) do |row,col|
			if row == 2 then z else 0 end
		end

		@points = transformation + @points
	end

	def rotate(x_rot:0,y_rot:0,z_rot:0,degrees:true)
		rotateX(x_rot:x_rot,degrees:degrees)
		rotateY(y_rot:y_rot,degrees:degrees)
		rotateZ(z_rot:z_rot,degrees:degrees)
	end

	def rotateX(x_rot:0,degrees:true)
		if degrees then 
			@x_rot += x_rot 
			x_rot = degToRads(x_rot)
		else 
			@x_rot += radsToDeg(x_rot) 
		end

		transformation = Matrix[
			[1, 0, 0],
			[0, Math.cos(x_rot), -Math.sin(x_rot)],
			[0, Math.sin(x_rot), Math.cos(x_rot)]
		]

		@points = transformation * @points
	end

	def rotateY(y_rot:0,degrees:true)
		if degrees then 
			@y_rot += y_rot
			y_rot = degToRads(y_rot) 
		else
			@y_rot += radsToDeg(y_rot)
		end

		transformation = Matrix[
			[Math.cos(y_rot), 0, Math.sin(y_rot)],
			[0, 1, 0],
			[-Math.sin(y_rot), 0, Math.cos(y_rot)]
		]

		@points = transformation * @points
	end

	def rotateZ(z_rot:0,degrees:true)
		if degrees then 
			@z_rot += z_rot
			z_rot = degToRads(z_rot) 
		else
			@z_rot += radsToDeg(z_rot)
		end

		transformation = Matrix[
			[Math.cos(z_rot), -Math.sin(z_rot), 0],
			[Math.sin(z_rot), Math.cos(z_rot), 0],
			[0, 0, 1]
		]

		@points = transformation * @points
	end

	def rotateGlobalX(x_rotg:0,degrees:true)
	end

	def rotateGlobalY(y_rotg:0,degrees:true)
	end

	def rotateGlobalZ(z_rotg:0,degrees:true)
	end
end

=begin
	Generates a 3D axis centered at the origin of the 3D vector space.
	Red represents the x axis, Green represents the y axis and Blue represents
	the z axis. 
=end
class Axis3d < Shape3d
	def initialize(
		origin:Vector[0,0,0],x_axis:Vector[1,0,0],y_axis:Vector[0,1,0],z_axis:Vector[0,0,1],
		size:50,space:)

		super(size:50,space:space)
		@colors = ['red','green','blue']
		@points = Matrix.columns(
			[(origin*size).to_a,(x_axis*size).to_a,(y_axis*size).to_a,(z_axis*size).to_a])
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

=begin
	Generates a cube in 3D space where 'x','y','z' denotes the position
	the cube (its center). 'size' determines the length of a side of the
	cube. 'color' denotes the color of the cube. 'space' is a Space3d
	object which determines the perspective of the cube.
=end
class Cube3d < Shape3d
	def initialize(
		x:0,y:0,z:0,
		size:100,color:'white',space:)
		super

		# Cube construction
		# Top of the cube
		cubetop = [
			[@x+@size/2.0,@y+@size/2.0,@z+@size/2.0],
			[@x-@size/2.0,@y+@size/2.0,@z+@size/2.0],
			[@x-@size/2.0,@y-@size/2.0,@z+@size/2.0],
			[@x+@size/2.0,@y-@size/2.0,@z+@size/2.0]]

		# Bottom of the cube
		cubebottom = cubetop.map do |e| e.dup end
		for i in 0..3 do
			cubebottom[i][2] -= size
		end

		# Cube Matrix
		@points = Matrix.columns([
			cubetop[0],cubetop[1],
			cubetop[2],cubetop[3],cubetop[0],
			cubebottom[0],cubebottom[1],cubetop[1],cubebottom[1],
			cubebottom[2],cubetop[2],cubebottom[2],
			cubebottom[3],cubetop[3],cubebottom[3],cubebottom[0]
			])	
	end
end

=begin
	Generates a pyramid in 3D space where 'x','y','z' denotes the position
	of the pyramid (the middle of the base). 'height' determines the height
	of the pyramid. 'size' determines the the length of one side of the base of
	the pyramid. 'color' denotes the color of the pyramid. 'space' is a Space3d
	object which determines the rotation and tilt of the pyramid.
=end
class Pyramid3d
	def initialize(
		x:0,y:0,z:0,
		x_rot:0,y_rot:0,z_rot:0,degrees:true,
		size:100,color:'white',space:)
		super
	end
end
