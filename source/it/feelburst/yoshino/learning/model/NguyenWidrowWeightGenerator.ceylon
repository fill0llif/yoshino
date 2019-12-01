import it.feelburst.yoshino.model {
	LayeredNeuralNetwork,
	BiasNeuron,
	Synapse
}
import ceylon.numeric.float {

	sqrt
}

shared final class NguyenWidrowWeightGenerator(
	LayeredNeuralNetwork neuralNetwork,
	Integer link,
	WeightGenerator wg = RandomWeightGenerator(-0.5, 0.5))
	satisfies WeightGenerator {
	
	assert (0 <= link < neuralNetwork.links.size);
	
	value wi = SingleLayerWeightInitialization(neuralNetwork,wg,link);
	wi.initWeights();
	
	Float beta(Integer inputs, Integer hiddens) =>
		0.7 * hiddens.float.power(1.0 / inputs);
	
	value b = beta(
		neuralNetwork.layer(link).size,
		neuralNetwork.layer(link + 1,false).size);
	
	Float norm({Float*} weights) =>
		sqrt(
			weights
			.map((Float weight) =>
				weight.powerOfInteger(2))
			.fold(0.0)(plus));
	
	shared actual Float generate(Synapse synapse) {
		if (synapse.left is BiasNeuron) {
			return RandomWeightGenerator(-b,b).generate(synapse);
		} else {
			value synapsesToOutput = neuralNetwork.synapsesTo(synapse.right);
			return b * synapse.weight / norm(synapsesToOutput*.weight);
		}
	}
}