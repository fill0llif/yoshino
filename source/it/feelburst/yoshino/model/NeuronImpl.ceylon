shared class NeuronImpl(
	shared actual String label,
	shared actual variable Function activationFunction,
	shared actual variable Float input = 0.0)
	extends Neuron(label) {}
