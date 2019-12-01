import it.feelburst.yoshino.model.visitor {
	Visitable
}

shared abstract class Neuron(label)
	of NeuronImpl | BiasNeuron
	satisfies Visitable {
	shared default String label;
	shared formal Function activationFunction;
	shared formal Float input;
	
	shared Float output =>
		activationFunction.apply(input);
	
	shared actual Boolean equals(Object that) =>
		if (is Neuron that) then
			label == that.label
		else
			false;
	
	shared actual Integer hash =>
		label.hash;
	
	shared actual String string =>
		"``label``(input=``input``)";
}
