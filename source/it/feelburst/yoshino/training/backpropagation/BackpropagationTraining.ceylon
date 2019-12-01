import it.feelburst.yoshino.io {
	SupervisedPairs
}
import it.feelburst.yoshino.learning.backpropagation {
	BackpropagationRule
}
import it.feelburst.yoshino.learning.model {
	WeightGenerator,
	RandomWeightGenerator,
	NguyenWidrowWeightGenerator
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

shared final class BackpropagationTraining(
	LayeredNeuralNetwork neuralNetwork,
	TrainingStrategy trainingStrategy,
	Float learningRate = 0.02,
	WeightGenerator wi(Integer link) =>
		if (link == 0) then
			NguyenWidrowWeightGenerator(neuralNetwork,link)
		else
			RandomWeightGenerator(-0.5, 0.5),
	shared actual SupervisedTrainingListener<BackpropagationRule> listener =
		SupervisedTrainingAdapter<BackpropagationRule>())
	satisfies SupervisedTraining<BackpropagationRule> {
	
	value learningRule = BackpropagationRule(
		neuralNetwork, 
		learningRate,
		wi,
		trainingStrategy.loss);
	
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
		while (!trainingStrategy.isTrainingDone()) {
			listener.beforeEpoch(learningRule);
			SupervisedPairs(
				trainingStrategy.trainingInputReader,
				neuralNetwork.inputs(false).size)
			.each(({Float*} trainings -> {Float*} targets) {
				listener.beforeWeightsUpdate(
					learningRule,
					trainings,targets,
					weights);
				learningRule.updateWeights(trainings, targets);
				listener.afterWeightsUpdate(
					learningRule,
					trainings, targets,
					weights);
			});
			listener.afterEpoch(learningRule);
		}
		listener.afterTraining(learningRule);
	}
}
