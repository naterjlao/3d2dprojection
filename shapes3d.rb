require 'matrix'
require 'ruby2d'
require_relative 'ruby3d.rb'
require_relative 'projection.rb'
require_relative 'matrixtransformations.rb'

=begin
	Generates a cube in 3D space where 'x','y','z' denotes the position
	the cube (its center). 'size' determines the length of a side of the
	cube. 'color' denotes the color of the cube. 'space' is a Space3d
	object which determines the perspective of the cube.
=end
class Cube3d < Shape3d
	def initialize(x:0,y:0,z:0,size:100,width:1,color:'white',space:)
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

class Circle3d < Shape3d
	def initialize(x:0,y:0,z:0,size:100,width:1,color:'white',space:,resolution:8)
		super(x:x,y:y,z:z,size:size,width:width,color:color,space:space)
		@resolution = resolutions
		@radius = size/2.0
		@points = Matrix.columns(generateCircumference(x,y,z,@radius,2*Math::PI/@resolution,@resolution))
	end

	# Generate points around a circle as defined by the following parameters:
	# 'x','y','z' defines the center of the circle. 'radius' defines the distance between the
	# circle's center and edges. 'step' is the radian amount of change between the points of
	# the circle. 'resolution' is the number of points the circle has. The higher the resolution,
	# the more detailed the circle becomes. 
	# Note that the method returns an array of array that represents the position in 3D space of 
	# the points in the circle. Note that the array is closed meanining that the first element of
	# the array is the same as the last element of the array.
	def generateCircumference(x,y,z,radius,step,resolution)
		i = 0
		circumference = []

		# Generate points 
		while i < resolution do
			circumference << [radius*Math.cos(i * step) + x, radius*Math.sin(i * step) + y, z]
			i += 1
		end
		circumference << circumference[0]

		return circumference
	end

	private :generateCircumference
end

class Sphere3d < Circle3d
	def initialize(x:0,y:0,z:0,size:100,width:1,color:'white',space:,resolution:8)
		super

		@northPole = Vector[x,y,z + radius]
		@southPole = Vector[x,y,z - radius]
		@latitudes = [@points]
		#@longitudes


	end

	def draw()
		@space.draw3d(points:@northPole,color:color,width:width)
		@space.draw3d(points:@southPole,color:color,width:width)
	end

	def generateLatitudes()
		steps = @radius * 2 / @resolutions
		i = 1
		lat = []
		while i < @resolution do


			i += 1
		end
	end

	def generateLongitudes()

	end

	private :generateLatitudes, :generateLongitudes
end

=begin
	Generates a pyramid in 3D space where 'x','y','z' denotes the position
	of the pyramid (the middle of the base). 'height' determines the height
	of the pyramid. 'size' determines the the length of one side of the base of
	the pyramid. 'color' denotes the color of the pyramid. 'space' is a Space3d
	object which determines the rotation and tilt of the pyramid.
=end
class Pyramid3d
	def initialize(x:0,y:0,z:0,x_rot:0,y_rot:0,z_rot:0,degrees:true,size:100,color:'white',space:)
		super
	end
end
