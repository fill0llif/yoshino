"Neuron linked by a bias"
shared final class BiasNeuron(shared actual String label)
	extends Neuron(label) {
	shared actual Function activationFunction = identity;
	shared actual Float input = 1.0;
}
