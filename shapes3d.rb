require 'matrix'
require 'ruby2d'
require_relative 'projection.rb'

=begin
	Represents the visual perspective of 3D space. The angle 'r' represents the orbital 
	rotation of the axis and 't' represents the tilt away from the z axis. The 'degrees'
	boolean represents if the value of the 'r' and 't' are in degrees. 'x' and 'y' are
	positional displacement of the 2 dimensional projection.
=end
class Space3d
	attr_accessor :r
	attr_accessor :t
	attr_accessor :degrees
	attr_accessor :x
	attr_accessor :y

	def initialize(r:0,t:0,degrees:true,x:320,y:240)
		@r = r
		@t = t
		@degrees = degrees
		@x = x
		@y = y
	end
end

=begin
	Generates a 3D axis centered at the origin of the 3D vector space.
	Red represents the x axis, Green represents the y axis and Blue represents
	the z axis. 
=end
class Axis3d
	def initialize(
		x_axis:Vector[1,0,0],y_axis:Vector[0,1,0],z_axis:Vector[0,0,1],
		length:50,width:1,space:)

		colors = ['red','green','blue']
		axis3d = Matrix.columns([x_axis.to_a,y_axis.to_a,z_axis.to_a])
		axis2d = length * project(r:space.r,t:space.t,
			points:axis3d,degrees:space.degrees)

		for i in 0..2 do
			Line2d.new(
				x1:space.x,y1:space.y,
				x2:(axis2d.column(i))[0] + space.x,
				y2:(axis2d.column(i))[1] + space.y,
				width:width,color:colors[i])
		end
	end
end

class Cube3d
	def initialize(x:0,y:0,z:0,size:100,color:'white',space:)
		cubetop = [
			[x+size/2.0,y+size/2.0,z+size/2.0],
			[x-size/2.0,y+size/2.0,z+size/2.0],
			[x-size/2.0,y-size/2.0,z+size/2.0],
			[x+size/2.0,y-size/2.0,z+size/2.0]]
		cubebottom = cubetop.map do |e| e.dup end
		for i in 0..3 do
			cubebottom[i][2] -= size
		end

		cube3d = Matrix.columns([
			cubetop[0],cubetop[1],
			cubetop[2],cubetop[3],cubetop[0],
			cubebottom[0],cubebottom[1],cubetop[1],cubebottom[1],
			cubebottom[2],cubetop[2],cubebottom[2],
			cubebottom[3],cubetop[3],cubebottom[3],cubebottom[0]
			])
		cube2d = project(r:space.r,t:space.t,points:cube3d,degrees:space.degrees)

		draw2d(points:cube2d,color:color,space:space)
	end
end

#Test
set width: 800
set height: 800

s = Space3d.new(t:40,x:(get :width)/2,y:(get :height)/2)
MAX_SIZE = 500
size = MAX_SIZE
shrink = true
update do
	clear
	Axis3d.new(space:s,length:100,width:1)
	Cube3d.new(space:s,size:size)

	# Rotate space
	if s.r < 360 then s.r += 1 else s.r = 0 end

	# resize cube
	if shrink then 
		size -= 1 
		if size < -MAX_SIZE then shrink = false end 
	else
		size += 1
		if size > MAX_SIZE then shrink = true end
	end
end
show



