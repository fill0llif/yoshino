import it.feelburst.yoshino.io {
	ValueInputReader
}
import it.feelburst.yoshino.learning {
	HebbRule
}
import it.feelburst.yoshino.model {
	LayeredNeuralNetwork
}

shared class HebbTraining(
	LayeredNeuralNetwork hebbNet,
	ValueInputReader<Float> trainingInputReader,
	Boolean splitting(Character ch) => ch.equals(','))
		satisfies SupervisedTraining {
	shared actual void train() {
		value learningRule = HebbRule(hebbNet);
		learningRule.initWeights();
		try (trainingInputReader = SupervisedTrainingInputReaderImpl(trainingInputReader, splitting)) {
			while (exists trainingSet = trainingInputReader.readTrainingPair(hebbNet.inputs(false).size)) {
				learningRule.updateWeights(trainingSet.key, trainingSet.item);
			}
		}
	}
}
