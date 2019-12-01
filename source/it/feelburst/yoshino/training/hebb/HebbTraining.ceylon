import it.feelburst.yoshino.io {
	SupervisedPairs
}
import it.feelburst.yoshino.learning.hebb {
	HebbRule
}
import it.feelburst.yoshino.model {
	LayeredNeuralNetwork,
	Synapse
}
import it.feelburst.yoshino.training {
	SupervisedTraining,
	SupervisedTrainingListener,
	SupervisedTrainingAdapter
}

import java.io {
	BufferedReader
}

shared final class HebbTraining(
	LayeredNeuralNetwork neuralNetwork,
	BufferedReader trainingInputReader(),
	Integer link = 0,
	shared actual SupervisedTrainingListener<HebbRule> listener =
		SupervisedTrainingAdapter<HebbRule>())
	satisfies SupervisedTraining<HebbRule> {
	
	value learningRule = HebbRule(neuralNetwork,link);
	
	shared actual void train() {
		value weights =>
			neuralNetwork.synapses
			.collect((Synapse synapse) =>
				synapse.weight);
		listener.beforeTraining(learningRule);
		learningRule.initWeights();
		listener.afterWeightsInitialization(
			learningRule,
			weights);
		listener.beforeEpoch(learningRule);
		SupervisedPairs(
			trainingInputReader,
			neuralNetwork.layer(link,false).size)
		.each(({Float*} trainings -> {Float*} targets) {
			listener.beforeWeightsUpdate(
				learningRule,
				trainings, targets,
				weights);
			learningRule.updateWeights(trainings, targets);
			listener.afterWeightsUpdate(
				learningRule,
				trainings, targets,
				weights);
		});
		listener.afterEpoch(learningRule);
		listener.afterTraining(learningRule);
	}
	
}
