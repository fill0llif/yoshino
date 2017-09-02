import it.feelburst.yoshino.model.visitor {
	Visitable
}

shared abstract class Neuron(label)
		of NeuronImpl | Bias
		satisfies Visitable {
	shared default String label;
	shared formal ActivationFunction activationFunction;
	shared formal Float input;
	
	shared String letter =>
		label
			.filter((Character char) => char.letter)
			.fold("")((String a, Character b) => "``a````b``");
	
	shared Integer number {
		value number = Integer.parse(
			label
				.filter((Character char) => char.digit)
				.fold("")((String a, Character b) => "``a````b``"));
		assert (is Integer number);
		return number;
	}
	
	shared Float output => activationFunction.apply(input);
	
	shared actual Boolean equals(Object that) =>
		if (is Neuron that) then label == that.label
		else false;
	
	shared actual Integer hash => label.hash;
	
	shared actual String string => "``label``(input=``input``)";
}
