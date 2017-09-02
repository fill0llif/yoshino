import it.feelburst.yoshino.model {
	Neuron,
	Synapse,
	NeuronImpl,
	LayeredNeuralNetwork
}

shared class HebbRule(LayeredNeuralNetwork neuralNetwork) satisfies SupervisedLearningRule {
	
	shared actual void initWeights() =>
		neuralNetwork.synapses
			.each((Synapse synapse) => synapse.weight = 0.0);
	
	shared actual void updateWeights([Float*] training, [Float*] target) {
		assert (neuralNetwork.inputs(false).size == training.size);
		assert (neuralNetwork.outputs.size == target.size);
		zipEntries([*neuralNetwork.inputs(false).narrow<NeuronImpl>()], training)
			.each((NeuronImpl neuron -> Float val) => neuron.input = val);
		zipEntries(neuralNetwork.outputs, target)
			.each((Neuron output -> Float val) =>
				neuralNetwork.inputs()
				.each((Neuron input) {
					assert (exists synapse = neuralNetwork.synapsesFromTo(input, output));
					synapse.weight = synapse.weight + input.input*val;
		}));
	}
}
