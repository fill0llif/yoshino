import it.feelburst.yoshino.io {
	ValueInputReader
}
import it.feelburst.yoshino.learning {
	PerceptronRule
}
import it.feelburst.yoshino.model {
	Synapse,
	LayeredNeuralNetwork
}
shared class PerceptronTraining(
	LayeredNeuralNetwork perceptron,
	Float learningRate,
	ValueInputReader<Float> trainingInputReader,
	Boolean splitting(Character ch) => ch.equals(','))
		satisfies SupervisedTraining {
	shared actual void train() {
		value learningRule = PerceptronRule(perceptron,learningRate);
		learningRule.initWeights();
		value synapsesWeights => perceptron.synapses.collect((Synapse synapse) => synapse.weight);
		variable [Float+]|[] previousSynapsesWeights = [];
		variable [Float+]|[] currentSynapsesWeights = synapsesWeights;
		variable [Boolean*] changes = [true];
		value learningDone => changes.every((Boolean change) => !change);
		while (!learningDone) {
			changes = [];
			try (trainingInputReader = SupervisedTrainingInputReaderImpl(trainingInputReader, splitting)) {
				while (exists trainingSet = trainingInputReader.readTrainingPair(perceptron.inputs(false).size)) {
					learningRule.updateWeights(trainingSet.key, trainingSet.item);
					previousSynapsesWeights = currentSynapsesWeights;
					currentSynapsesWeights = synapsesWeights;
					changes = changes.withTrailing(currentSynapsesWeights != previousSynapsesWeights);
				}
			}
		}
	}
}