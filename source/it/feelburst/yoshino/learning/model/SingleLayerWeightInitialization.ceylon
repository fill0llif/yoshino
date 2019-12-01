import it.feelburst.yoshino.model {
	LayeredNeuralNetwork,
	Synapse
}

shared class SingleLayerWeightInitialization(
	LayeredNeuralNetwork neuralNetwork,
	WeightGenerator wg,
	Integer link = 0)
	satisfies WeightInitialization {
	
	//synapses of the layer on which the rule is applied
	value synapses = neuralNetwork.link(link);
	
	shared default actual void initWeights() =>
		neuralNetwork.update(
			zipEntries(
				synapses,
				synapses.map((Synapse synapse) =>
					wg.generate(synapse))));
	
}
