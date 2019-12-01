import it.feelburst.yoshino.model {
	LayeredNeuralNetwork
}
shared class MultiLayerWeightInitialization(
	LayeredNeuralNetwork neuralNetwork,
	WeightGenerator wg(Integer link))
	satisfies WeightInitialization {
	
	value layersWeightInitialization =
		(0:neuralNetwork.links.size)
		.map((Integer link) =>
			SingleLayerWeightInitialization(neuralNetwork,wg(link),link));
	
	shared default actual void initWeights() =>
		layersWeightInitialization
		.each((SingleLayerWeightInitialization wi) =>
			wi.initWeights());
	
}
