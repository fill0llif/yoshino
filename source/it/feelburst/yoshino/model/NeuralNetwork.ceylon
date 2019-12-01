import it.feelburst.yoshino.model.visitor {
	Visitable
}

shared interface NeuralNetwork satisfies Visitable {
	
	shared formal Neuron[] neurons;
	shared formal Synapse[]synapses;
	
	shared formal {Float*} apply({Float*} values);
	
	shared Neuron? neuron(String label) =>
		neurons.find((Neuron neuron) =>
			neuron.label == label);
	
	shared Boolean contains(Neuron neuron) =>
		neuron in neurons;
	
	shared {Synapse*} synapsesFrom(Neuron from) =>
		synapses.filter((Synapse synapse) =>
			synapse.left == from);
	
	shared {Synapse*} synapsesTo(Neuron to,Boolean withBias = true) =>
		synapses.filter((Synapse synapse) =>
			synapse.right == to && 
			(if (withBias) then
				true
			else
				!synapse.left is BiasNeuron));
	
	shared Synapse? synapsesFromTo(Neuron from, Neuron to) =>
		synapses.find((Synapse synapse) =>
			synapse.left == from && synapse.right == to);
	
	shared {Synapse*} biasSynapsesFrom(BiasNeuron bias) =>
		synapses.filter((Synapse synapse) =>
			synapse.left is BiasNeuron && synapse.left == bias);
	
	shared Synapse? biasSynapseTo(Neuron to) =>
		synapses.find((Synapse synapse) =>
			synapse.left is BiasNeuron && synapse.right == to);
	
	shared void update(
		{<Synapse->Float>*} synapsesWeights) =>
		synapsesWeights
		.each((Synapse synapse -> Float weight) =>
			synapse.weight = weight);
	
	shared void sum(
		{<Synapse->Float>*} synapsesWeights) =>
		synapsesWeights
		.each((Synapse synapse -> Float weight) =>
			synapse.weight += weight);
		
	shared default actual String string =>
		synapses.string;
}
