shared class NeuronImpl(label, activationFunction, input = 0.0) extends Neuron(label) {
	shared actual String label;
	shared actual variable ActivationFunction activationFunction;
	shared actual variable Float input;
}
