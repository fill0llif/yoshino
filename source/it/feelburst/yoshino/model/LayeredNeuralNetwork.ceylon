import ceylon.collection {
	HashMap
}

import it.feelburst.yoshino.model.visitor {
	NetInputVisitor
}

shared final class LayeredNeuralNetwork satisfies NeuralNetwork {
	
	[[Neuron+]+] neuronMap;
	
	shared new byLayers([Layer+] neuronLayers) {
		this.neuronMap = neuronLayers.collect((Layer layer) =>
			let (nonBias = (1..layer.neurons).collect((Integer index) =>
				NeuronImpl(
					layer.label(index),
					layer.activationFunction(index))))
			if (layer.bias) then [Bias(layer.label(0)),*nonBias]
			else nonBias);
	}
	
	shared new byNeurons([[Neuron+]+] neuronMap) {
		this.neuronMap = neuronMap;
	}
	
	shared Map<Integer,[Neuron+]> layerNeurons = HashMap<Integer,[Neuron+]> {
		entries = neuronMap.indexed;
	};
	
	shared actual [Neuron+] neurons =
		[*neuronMap.flatMap(([Neuron+] layerNeurons) => layerNeurons)];
	
	shared actual [Synapse*] synapses =
		[
			for (adjacentLayersNeurons in neuronMap.paired)
				for (output in adjacentLayersNeurons.last)
					for (input in adjacentLayersNeurons.first)
						Synapse(input, output)
		];
	
	shared Integer layers =>
		layerNeurons.keys.size;
	
	shared [Neuron+] layer(Integer layer) {
		assert (exists neurons = layerNeurons[layer]);
		return neurons;
	}
	
	shared [Neuron+] inputs(Boolean bias = true) {
		value inputs = layer(0);
		if (bias) {
			return inputs;
		} else {
			assert (nonempty nonBias = 
				[*inputs.filter(not((Neuron neuron) => neuron is Bias))]);
			return nonBias;
		}
	}
	
	shared [Neuron+] outputs =>
		layer(layers - 1);
	
	shared Boolean hasBias(Integer layer) =>
		if (exists l = layerNeurons[layer]) then
			l.find((Neuron neuron) => neuron is Bias) exists
		else
			false;
	
	shared Bias? bias(Integer layer) =>
		if (exists l = layerNeurons[layer],
			is Bias bias = l.find((Neuron neuron) => neuron is Bias)) then
			bias
		else
			null;
	
	shared actual [Float*] apply([Float*] values) {
		assert (inputs(false).size == values.size);
		[Float*] apply(NeuronImpl[] inputs,NeuronImpl[] outputs,[Float*] values) {
			zipEntries(inputs, values)
				.each((NeuronImpl input -> Float val) => input.input = val);
			return outputs.collect((NeuronImpl output) {
				value visitor = NetInputVisitor(output);
				visitor.visit(this);
				output.input = visitor.netInput;
				value outputVal = output.output;
				return outputVal;
			});
		}
		[Float*] nextPair({Integer[2]*} pairedLayers,[Float*] values) =>
			if (exists pair = pairedLayers.first) then
				let (inputs = [*layer(pair.first).narrow<NeuronImpl>()])
				let (outputs = [*layer(pair.last).narrow<NeuronImpl>()])
				nextPair(pairedLayers.rest,apply(inputs, outputs, values))
			else
				values;
		return nextPair((0:layers).paired, values);
	}
}
