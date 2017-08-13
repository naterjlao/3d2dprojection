require 'matrix'
require 'ruby2d'
require_relative 'projection.rb'

class Axis3d
	def initialize(x_axis:Vector[1,0,0],y_axis:Vector[0,1,0],z_axis:Vector[0,0,1],
		size:50,x:320,y:240,width:1,r:0,t:0,degrees:true)

		colors = ['red','green','blue']
		axis3d = Matrix.columns([x_axis.to_a,y_axis.to_a,z_axis.to_a])
		axis2d = size*project(r:r,t:t,points:axis3d) 
		#+ Matrix[[x,0],[0,y]]*Matrix[[1,1,1,1,1,1,1],[1,1,1,1,1,1,1]]

		for i in 0..2 do
			Line2d.new(
				x1:x,y1:y,
				x2:(axis2d.column(i))[0] + x,
				y2:(axis2d.column(i))[1] + y,
				width:width,color:colors[i])
		end
	end
end

class Cube3d
	def initialize(x:0,y:0,z:0,size:100)
	end
end

#Test
orbit = 0
tilt = 0
update do
	clear
	Axis3d.new(r:orbit,t:tilt/2,x:(get :width)/2,y:(get :height)/2,size:100,width:5)
	if orbit < 360 then orbit += 1 else orbit = 0 end
	if tilt < 720 then tilt += 1 else tilt = 0 end
end
show



