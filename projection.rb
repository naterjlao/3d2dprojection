=begin

transformation matrix:

[	cos(r) 			sin(r) 			0
 	sin(r)*sin(t)	cos(r)*sin(t)	cos(t)	]
=end

require 'matrix'
require 'ruby2d'
require_relative 'shapes2d.rb'

def degToRads(degrees)
	return degrees*Math::PI/180
end


def project(r:0, t:0, points:, degrees:true)
	# TODO what if the points is a vector?
	if points.class != Matrix || points.row_size != 3 then
		return false
	end

	if degrees then 
		r = degToRads(r)
		t = degToRads(t)
	end


	tMat = Matrix[[Math.cos(r), Math.sin(r), 0],
		[Math.cos(r - Math::PI/2)*Math.sin(t), Math.sin(r - Math::PI/2)*Math.sin(t), -Math.cos(t)]]

	return tMat * points
end


class Axis3d
	def initialize(x_axis:Vector[1,0,0],y_axis:Vector[0,1,0],z_axis:Vector[0,0,1],
		size:50,x:320,y:240,r:0,t:0,degrees:true)

		origin = [0,0,0]
		axis3d = Matrix.columns([
			origin,x_axis.to_a,origin,y_axis.to_a,origin,z_axis.to_a,origin])

		axis2d = size*project(r:r,t:t,points:axis3d) + 
			Matrix[[x,0],[0,y]]*Matrix[[1,1,1,1,1,1,1],[1,1,1,1,1,1,1]]

		drawLines(axis2d)
	end
end

class Cube3d
	def initialize(x:0,y:0,z:0,size:100)
	end
end

def drawLines(points)
	if points.class == Matrix && points.row_size == 2 && points.column_size > 0 then
		col_size = points.column_size
		col = 0
		if col_size > 2 then
			while (col + 1) < col_size do
				x1 = points[0,col]
				y1 = points[1,col]
				x2 = points[0,col+1]
				y2 = points[1,col+1]
				#puts "placing start at: #{x1},#{y1} placing end at: #{x2} #{y2}"

				Line2d.new(x1:x1,y1:y1,x2:x2,y2:y2)

				col += 1
			end
		else
			x = points[0,0]
			y = points[1,0]
			#puts "placing dot at: #{x} #{y}"
		end
	end
end


#Test
orbit = 0
update do
	clear
	Axis3d.new(r:orbit,t:45)

	if orbit < 360 then orbit += 1 else orbit = 0 end
end
show