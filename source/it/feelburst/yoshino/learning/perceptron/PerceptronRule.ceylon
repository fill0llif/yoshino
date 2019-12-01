import it.feelburst.yoshino.learning.model {
	WeightGenerator,
	NilWeightGenerator,
	SingleLayerWeightInitialization
}
import it.feelburst.yoshino.model {
	Neuron,
	LayeredNeuralNetwork
}
import it.feelburst.yoshino.learning {

	SupervisedLearningRule
}

shared final class PerceptronRule(
	LayeredNeuralNetwork neuralNetwork,
	Float learningRate,
	Integer link = 0,
	WeightGenerator wg = NilWeightGenerator())
	extends SingleLayerWeightInitialization(neuralNetwork,wg,link)
	satisfies SupervisedLearningRule {
	
	assert (0.0 < learningRate <= 1.0);
	
	shared actual void updateWeights({Float*} trainings, {Float*} targets) {
		"Trainings and inputs have not the same size"
		assert (neuralNetwork.layer(link,false).size == trainings.size);
		"Targets and outputs have not the same size"
		assert (neuralNetwork.layer(link + 1).size == targets.size);
		//init inputs with trainings
		neuralNetwork.feed(trainings);
		//for each computed output and its target
		value inputs = neuralNetwork.layer(link);
		value outputs = neuralNetwork.layer(link + 1);
		value responses = neuralNetwork.apply(trainings);
		zipEntries(
			outputs,
			zipPairs(responses, targets))
		.each((Neuron output -> [Float response, Float target]) {
			//if they differ
			if (response != target) {
				neuralNetwork.sum(
					zipEntries(
						neuralNetwork.synapsesTo(output),
						inputs.map((Neuron input) =>
							let (deltaWeight = learningRate * input.input * target)
								deltaWeight)));
			}
		});
	}
	
}