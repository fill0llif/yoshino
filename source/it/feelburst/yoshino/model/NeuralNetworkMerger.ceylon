shared final class NeuralNetworkMerger(
	LayeredNeuralNetwork([[Neuron+]+]) constructor) {
	
	shared Boolean isAppendable(
		LayeredNeuralNetwork left,
		LayeredNeuralNetwork right) =>
		left.outputs == right.inputs(false);
	
	shared LayeredNeuralNetwork append(
		LayeredNeuralNetwork left,
		LayeredNeuralNetwork right) {
		assert (isAppendable(left,right));
		assert (is [[Neuron+]+] exceptLast = 
			[*left.layerNeurons
			.collect((Integer layer -> [Neuron+] neurons) => neurons)]
			.exceptLast);
		value net = constructor(
			exceptLast
			.append(
				(0:right.layers)
				.collect((Integer l) => right.layer(l))
			)
		);
		left.synapses.append(right.synapses).each((Synapse synapse) {
			assert (exists s = net.synapses.find((Synapse s) => s == synapse));
			s.weight = synapse.weight;
		});
		return net;
	}
	
	shared Boolean isMergeable(
		LayeredNeuralNetwork left,
		LayeredNeuralNetwork right) =>
		left.inputs() == right.inputs() && 
		left.layers==2 && left.layers==right.layers;
	
	shared LayeredNeuralNetwork merge(
		LayeredNeuralNetwork left,
		LayeredNeuralNetwork right) {
		assert (isMergeable(left,right));
		value net = constructor([
			left.inputs(),
			left.outputs
				.append([*right.neurons.filter(not((Neuron neuron) => neuron in left.neurons))])
		]);
		left.synapses.append(right.synapses).each((Synapse synapse) {
			assert (exists s = net.synapses.find((Synapse s) => s == synapse));
			s.weight = synapse.weight;
		});
		return net;
	}
	
}