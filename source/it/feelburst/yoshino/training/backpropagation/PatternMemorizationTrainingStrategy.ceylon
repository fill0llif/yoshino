import it.feelburst.yoshino.io {
	SupervisedPairs
}
import it.feelburst.yoshino.model {
	LayeredNeuralNetwork,
	Function,
	Constant,
	Linear
}

import java.io {
	BufferedReader
}

shared final class PatternMemorizationTrainingStrategy(
	LayeredNeuralNetwork neuralNetwork,
	shared actual BufferedReader trainingInputReader(),
	shared Float error = 0.05,
	shared actual Function loss(Float target) =>
		Constant(1.0 / 2.0) * (Linear(1.0,-target) ^ Constant(2.0)))
	satisfies TrainingStrategy {
	
	shared actual Boolean isTrainingDone() =>
		let (trainingSet = SupervisedPairs(
			trainingInputReader,
			neuralNetwork.inputs(false).size))
		let (averageLoss = 
		trainingSet
		.map(({Float*} trainings -> {Float*} targets) =>
			let (outputs = neuralNetwork.apply(trainings))
			zipEntries(outputs,targets)
			.map((Float output -> Float target) =>
				loss(target).apply(output))
			.fold(0.0)((Float partial, Float element) =>
				partial + element))
		.fold(0.0)((Float partial, Float element) =>
			partial + element) / trainingSet.size)
		averageLoss < error;
	
}
