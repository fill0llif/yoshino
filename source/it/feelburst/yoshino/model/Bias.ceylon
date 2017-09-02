shared final class Bias(label) extends Neuron(label) {
	shared actual String label;
	shared actual ActivationFunction activationFunction = identity;
	shared actual Float input = 1.0;
}
