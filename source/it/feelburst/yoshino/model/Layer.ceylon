shared class Layer(
	shared String label(Integer index), 
	shared ActivationFunction activationFunction(Integer index),
	shared Integer neurons = 1, 
	shared Boolean bias = false) {}