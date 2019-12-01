
import it.feelburst.yoshino.learning {
	SupervisedLearningRule
}
import it.feelburst.yoshino.learning.model {
	NilWeightGenerator,
	SingleLayerWeightInitialization
}
import it.feelburst.yoshino.model {
	LayeredNeuralNetwork,
	Neuron
}

"Extended hebb rule in which weight are updated 
 even when neurons do not fire at the same time"
shared final class HebbRule(
	LayeredNeuralNetwork neuralNetwork,
	Integer link = 0)
	extends SingleLayerWeightInitialization(neuralNetwork,NilWeightGenerator(),link)
	satisfies SupervisedLearningRule {
	
	shared actual void updateWeights({Float*} trainings, {Float*} targets) {
		"Trainings and inputs have not the same size"
		assert (neuralNetwork.layer(link,false).size == trainings.size);
		"Targets and outputs have not the same size"
		assert (neuralNetwork.layer(link + 1).size == targets.size);
		//init inputs with trainings
		neuralNetwork.feed(trainings);
		//retrieve its inputs
		value inputs = neuralNetwork.layer(link);
		value synapses = neuralNetwork.link(link);
		neuralNetwork.sum(
			zipEntries(
				synapses,
				targets.product(inputs)
				.map(([Float target, Neuron input]) =>
					let (deltaWeight = input.input * target)
						deltaWeight)));
	}
}
