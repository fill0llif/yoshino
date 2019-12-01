import it.feelburst.yoshino.learning {
	SupervisedLearningRule
}
import it.feelburst.yoshino.learning.model {
	WeightGenerator,
	NguyenWidrowWeightGenerator,
	RandomWeightGenerator,
	MultiLayerWeightInitialization
}
import it.feelburst.yoshino.model {
	LayeredNeuralNetwork,
	Neuron,
	Synapse,
	Function,
	Linear,
	Constant
}

shared final class BackpropagationRule(
	LayeredNeuralNetwork neuralNetwork,
	Float learningRate = 0.02,
	WeightGenerator wi(Integer link) =>
		if (link == 0) then
			NguyenWidrowWeightGenerator(neuralNetwork,link)
		else
			RandomWeightGenerator(-0.5, 0.5),
	Function loss(Float target) =>
		Constant(1.0 / 2.0) * (Linear(1.0,-target) ^ Constant(2.0)))
	extends MultiLayerWeightInitialization(neuralNetwork,wi)
	satisfies SupervisedLearningRule {
	
	assert (0.0 < learningRate <= 1.0);
	
	shared actual void updateWeights({Float*} trainings, {Float*} targets) {
		assert (neuralNetwork.inputs(false).size == trainings.size);
		assert (neuralNetwork.outputs.size == targets.size);
		
		// Feedforward
		value outputs = neuralNetwork.apply(trainings);
		
		// Backpropagation
		value deltaWeightsLayer = (0:neuralNetwork.links.size)
		.reversed
		.flatMap((Integer link) =>
			deltaWeights(link,outputs,targets));
		
		// Weights update
		neuralNetwork.sum(deltaWeightsLayer);
	}
	
	{<Neuron->Float>*} losses(
		Integer link,
		{Float*} outputs,
		{Float*} targets) {
		assert (0 <= link < neuralNetwork.links.size);
		return
		if (link == neuralNetwork.links.size - 1) then
			zipEntries(
				neuralNetwork.outputs,
				zipPairs(outputs,targets)
			.map(([Float output, Float target]) =>
				let (lss = -loss(target).derivative.apply(output))
				lss))
		else
			let (lossesPerOutput = backpropErrors(link + 1,outputs,targets)
			.flatMap((Neuron output -> Float backpropError) =>
				neuralNetwork.synapsesTo(output)
				.map((Synapse synapse) =>
					synapse.left -> backpropError * synapse.weight)))
			lossesPerOutput;
	}
	
	{<Neuron->Float>*} backpropErrors(
		Integer link,
		{Float*} outputs,
		{Float*} targets) {
		assert (0 <= link < neuralNetwork.links.size);
		return this.losses(link,outputs,targets)
			.map((Neuron output -> Float loss) =>
				output -> loss * output.activationFunction.derivative.apply(output.input));
	}
	
	{<Synapse->Float>*} deltaWeights(
		Integer link,
		{Float*} outputs,
		{Float*} targets) {
		assert (0 <= link < neuralNetwork.links.size);
		return
		let (deltaWeightsPerOutput = backpropErrors(link,outputs,targets)
			.flatMap((Neuron output -> Float backpropError) =>
				neuralNetwork.synapsesTo(output)
				.map((Synapse synapse) =>
					synapse -> learningRate * backpropError * synapse.left.output)))
		deltaWeightsPerOutput;
	}
	
}