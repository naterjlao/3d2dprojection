=begin
	This Module provides matrices that can be mulitplied on the left of a Vector
	or a Matrix to output a desired linear transformation. Note that for all matrices
	that require an angle, the RADIAN form of that angle must be used.

	Resources for the following matrices can be found in:
	https://en.wikipedia.org/wiki/Rotation_matrix

	Author: Nate Lao
=end
require 'matrix'

=begin
	Contains methods that return a projection matrix from a higher dimension
	matrix to a lower dimensional matrix.
=end
module ProjectionMatrix

	# Returns a matrix that projects a 3 dimensional set of points into
	# 2 dimensional plane that intersects with the origin. The angle 'r'
	# represents the amount of rotation of plane around the z axis. (Where
	# an angle 0 represents the plane inline with the x axis and where the
	# angle follows the right hand rule). The angle 't' represents the tilt
	# away from the z axis. (This also follows the right hand rule).
	def ProjectionMatrix.project3d2d(r,t)
		return Matrix[
			[	# basis for the x component of the plane
				Math.cos(r), 
				Math.sin(r), 
				0
			],
			[	# basis for the y component of the plane
				Math.cos(r+Math::PI/2)*Math.sin(t), 
				Math.sin(r+Math::PI/2)*Math.sin(t), 
				Math.cos(t)
			]
		]
	end

end

=begin
	Contains methods that return a rotational matrix based on the given angle of
	rotation. Note that all angles given must be in radian form. The rotation is
	based off of the right hand rule.
=end
module RotationMatrix

	# Returns a matrix that represents a 2 dimension rotation around the origin.
	def RotationMatrix.rotate2d(theta)
		return Matrix[
			[Math.cos(theta), (-Math.sin(theta))],
			[Math.sin(theta), Math.cos(theta)]
		]
	end

	# Returns a matrix that represents a 3 dimensional rotation around x axis
	def RotationMatrix.rotateX3d(theta)
		return Matrix[
			[1, 0, 0],
			[0, Math.cos(theta), (-Math.sin(theta))],
			[0, Math.sin(theta), Math.cos(theta)]
		]
	end

	# Returns a matrix that represents a 3 dimensional rotation around y axis
	def RotationMatrix.rotateY3d(theta)
		return Matrix[
			[Math.cos(theta), 0, Math.sin(theta)],
			[0, 1, 0],
			[(-Math.sin(theta)), 0, Math.cos(theta)]
		]
	end

	# Returns a matrix that represents a 3 dimensional rotation around z axis
	def RotationMatrix.rotateZ3d(theta)
		return Matrix[
			[Math.cos(theta), (-Math.sin(theta)), 0],
			[Math.sin(theta), Math.cos(theta), 0],
			[0, 0, 1]
		]
	end
end


module MovementMatrix
	def MovementMatrix.moveX2d(disp,num_cols)

	end

	def MovementMatrix.moveY2d(disp,num_cols)

	end

	def MovementMatrix.moveX3d(disp,num_cols)

	end

	def MovementMatrix.moveY3d(disp,num_cols)

	end

	def MovementMatrix.moveZ3d(disp,num_cols)
		
	end
end







