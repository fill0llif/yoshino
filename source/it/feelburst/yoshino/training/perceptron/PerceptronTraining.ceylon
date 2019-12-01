import it.feelburst.yoshino.io {
	SupervisedPairs
}
import it.feelburst.yoshino.learning.perceptron {
	PerceptronRule
}
import it.feelburst.yoshino.model {
	Synapse,
	LayeredNeuralNetwork
}
import it.feelburst.yoshino.training {
	SupervisedTraining,
	SupervisedTrainingAdapter,
	SupervisedTrainingListener
}

import java.io {
	BufferedReader
}

shared final class PerceptronTraining(
	LayeredNeuralNetwork neuralNetwork,
	Float learningRate,
	BufferedReader trainingInputReader(),
	Integer link = 0,
	shared actual SupervisedTrainingListener<PerceptronRule> listener =
		SupervisedTrainingAdapter<PerceptronRule>())
		satisfies SupervisedTraining<PerceptronRule> {
	
	value learningRule = PerceptronRule(neuralNetwork, learningRate, link);
	
	shared actual void train() {
		value weights =>
			neuralNetwork.synapses
			.collect((Synapse synapse) =>
				synapse.weight);
		variable [Float+]|[] previousWeights = weights;
		listener.beforeTraining(learningRule);
		learningRule.initWeights();
		listener.afterWeightsInitialization(
			learningRule,
			weights);
		variable Boolean isChanging = true;
		//while there are changes
		while (isChanging) {
			variable value hasChanged = false;
			listener.beforeEpoch(learningRule);
			SupervisedPairs(
				trainingInputReader,
				neuralNetwork.layer(link,false).size)
			.each(({Float*} trainings -> {Float*} targets) {
				listener.beforeWeightsUpdate(
					learningRule,
					trainings, targets,
					previousWeights);
				learningRule.updateWeights(trainings, targets);
				listener.afterWeightsUpdate(
					learningRule,
					trainings, targets,
					weights);
				hasChanged ||= zipPairs(weights,previousWeights)
					//if there is at least
					.any(([Float current,Float previous]) =>
						//a weight that has changed
						current != previous);
				previousWeights = weights;
			});
			isChanging &&= hasChanged;
			listener.afterEpoch(learningRule);
		}
		listener.afterTraining(learningRule);
	}
}
