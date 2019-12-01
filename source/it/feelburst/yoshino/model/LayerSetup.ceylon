shared final class LayerSetup(
	shared String label(Integer index), 
	shared Function activationFunction(Integer index),
	shared Integer size = 1, 
	shared Boolean withBias = false) {
	shared {Neuron+} neurons =>
		let (nonBias = (1..size).map((Integer index) =>
			NeuronImpl(
				label(index),
				activationFunction(index))))
		if (withBias) then
			nonBias.follow(BiasNeuron(label(0)))
		else
			nonBias;
	shared LayerSetup merge(LayerSetup other) =>
		LayerSetup(
			(Integer index) =>
				if (index <= this.size) then
					this.label(index)
				else
					other.label(index),
			(Integer index) =>
				if (index <= this.size) then
					this.activationFunction(index)
				else
					other.activationFunction(index),
			this.size + other.size,
			this.withBias || other.withBias
		);
}