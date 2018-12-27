# Trigonometry Functions
def degToRads(degrees)
	return degrees*Math::PI/180
end

def sin(degrees) 
	return Math.sin(degToRads(degrees))
end

def cos(degrees)
	return Math.cos(degToRads(degrees))
end