import it.feelburst.yoshino.model.visitor {
	Visitable
}

shared interface NeuralNetwork satisfies Visitable {
	
	shared formal [Neuron+] neurons;
	shared formal [Synapse*] synapses;
	
	shared formal [Float*] apply([Float*] values);
	
	shared Neuron? neuron(String label) =>
		neurons.find((Neuron neuron) => neuron.label == label);
	
	Boolean(Synapse) neuronOrLabelEquals(Neuron(Synapse) neuron,Neuron|String neuronOrLabel) =>
		(Synapse synapse) =>
			if (is String neuronOrLabel) then neuron(synapse).label == neuronOrLabel
			else neuron(synapse) == neuronOrLabel;
	
	shared [Synapse*] synapsesFrom(Neuron|String from) =>
		[*synapses.filter(neuronOrLabelEquals((Synapse synapse) => synapse.left, from))];
	
	shared [Synapse*] synapsesTo(Neuron|String to) =>
		[*synapses.filter(neuronOrLabelEquals((Synapse synapse) => synapse.right, to))];
	
	shared Synapse? synapsesFromTo(Neuron|String from, Neuron|String to) =>
		set<Synapse>(synapsesFrom(from))
		.intersection<Synapse>(set<Synapse>(synapsesTo(to)))
		.first;
}
