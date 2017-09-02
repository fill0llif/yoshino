import it.feelburst.yoshino.model {
	Synapse,
	Neuron,
	NeuronImpl,
	LayeredNeuralNetwork
}
shared class PerceptronRule(
	LayeredNeuralNetwork neuralNetwork,
	Float learningRate) satisfies SupervisedLearningRule {
	
	assert (0.0 < learningRate <= 1.0);
	
	shared actual void initWeights() =>
		neuralNetwork.synapses
			.each((Synapse synapse) => synapse.weight = 0.0);
	
	shared actual void updateWeights(Float[] training, Float[] target) {
		assert (neuralNetwork.inputs(false).size == training.size);
		assert (neuralNetwork.outputs.size == target.size);
		zipEntries([*neuralNetwork.inputs(false).narrow<NeuronImpl>()], training)
			.each((NeuronImpl neuron -> Float val) => neuron.input = val);
		zipPairs(neuralNetwork.outputs,zipEntries(neuralNetwork.apply(training), target))
			.each(([Neuron output, Float outputVal -> Float targetVal]) {
			if (outputVal != targetVal) {
				neuralNetwork.inputs().each((Neuron input) {
					assert (exists synapse = neuralNetwork.synapsesFromTo(input, output));
					value deltaWeight = learningRate * input.input * targetVal;
					synapse.weight = synapse.weight + deltaWeight;
				});
			}
		});
	}
	
}