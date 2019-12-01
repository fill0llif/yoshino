import ceylon.collection {
	HashSet
}

import it.feelburst.yoshino.model.visitor {
	NetInputVisitor
}

shared class LayeredNeuralNetwork({LayerSetup*} layersSetup) satisfies NeuralNetwork {
	
	/*
	 for neurons data sequences has been used because iterables produce each time
	 different objects (even just assigning it to another variable)
	 */
	
	shared [[Neuron+]+]|[] layers = layersSetup
		.collect((LayerSetup layer) =>
			layer.neurons.sequence());
	
	shared [[Synapse*]+]|[] links = layers.paired
		.collect(([Neuron+][2] link) =>
			[
				for (output in link.last)
					for (input in link.first)
						if (!output is BiasNeuron)
							Synapse(input, output)
			]);
			
	shared actual [Neuron+]|[] neurons =
		layers.flatMap(([Neuron+] neurons) =>
			neurons)
		.sequence();
	
	shared actual [Synapse+]|[] synapses =
		links.flatMap(([Synapse*] link) =>
			link)
		.sequence();
	
	shared Integer size =>
		layers.size;
	
	LayerSetup? layerSetup(Integer layer) =>
		if (layer >= 0,exists lyr = layersSetup.getFromFirst(layer)) then
			lyr
		else
			null;
	
	shared {Neuron*} layer(Integer layer,Boolean bias = true) =>
		if (exists lyr = layers.get(layer)) then
			if (bias) then
				lyr
			else
				lyr.filter(not((Neuron neuron) =>
					neuron is BiasNeuron))
		else
			{};
	
	shared {Synapse*} link(Integer link) =>
		if (exists links = links.get(link)) then
			links
		else
			{};
	
	shared {Neuron*} inputs(Boolean withBias = true) =>
		layer(0,withBias);
	
	shared {Neuron*} outputs =>
		layer(size - 1);
	
	shared BiasNeuron? bias(Integer layer) =>
		if (exists neurons = layers.get(layer),
			is BiasNeuron bias = neurons.find((Neuron neuron) =>
				neuron is BiasNeuron)) then
			bias
		else
			null;
	
	shared Boolean hasBias(Integer layer) =>
		bias(layer) exists;
	
	shared void feed({Float*} inputs) =>
		zipEntries(
			this.inputs(false).narrow<NeuronImpl>(),
			inputs)
		.each((NeuronImpl neuron -> Float val) =>
			neuron.input = val);
	
	shared actual {Float*} apply({Float*} values) {
		assert (this.inputs(false).size == values.size);
		{Float*} apply({NeuronImpl*} inputs,{NeuronImpl*} outputs,{Float*} values) {
			zipEntries(inputs, values)
			.each((NeuronImpl input -> Float val) =>
				input.input = val);
			return outputs.map((NeuronImpl output) {
				value visitor = NetInputVisitor(output);
				visitor.visit(this);
				output.input = visitor.netInput;
				value outputVal = output.output;
				return outputVal;
			});
		}
		{Float*} nextPair({Integer[2]*} pairedLayers,{Float*} values) {
			if (exists pair = pairedLayers.first) {
				return nextPair(
					pairedLayers.rest,
					apply(
						layer(pair.first).narrow<NeuronImpl>(),
						layer(pair.last).narrow<NeuronImpl>(),
						values));
			} else {
				return values;
			}
		}
		return nextPair((0:size).paired, values);
	}
	
	shared LayeredNeuralNetwork append(LayeredNeuralNetwork other) {
		"This outputs and other inputs are not equivalent"
		assert (
			HashSet<Neuron> {
				elements = this.outputs;
			}.complement(HashSet<Neuron> {
				elements = other.inputs(false);
			}).empty);
		value net = LayeredNeuralNetwork(
			this.layersSetup.exceptLast.chain(other.layersSetup));
		//for each link
		(0:net.links.size).each((Integer link) {
			value originalLink =
			if (link < this.links.size) then
				this.link(link)
			else
				other.link(link - this.links.size);
			net.update(
				zipEntries(
					net.link(link),
					originalLink*.weight));
		});
		return net;
	}
	
	shared class Join(LayeredNeuralNetwork other) {
		shared LayeredNeuralNetwork on(Integer leftLayer,Integer rightLayer) {
			"This layer and other layer are equivalent"
			assert (
				!outer.layer(leftLayer,false).containsAny(other.layer(rightLayer,false)));
			"This previous layer and other previous layer are not equivalent"
			assert (
				HashSet<Neuron> {
					elements = outer.layer(leftLayer - 1,false);
				}.complement(HashSet<Neuron> {
					elements = other.layer(rightLayer - 1,false);
				}).empty);
			"This next layer and other next layer are not equivalent"
			assert (
				HashSet<Neuron> {
					elements = outer.layer(leftLayer + 1,false);
				}.complement(HashSet<Neuron> {
					elements = other.layer(rightLayer + 1,false);
				}).empty);
			"No layer at index ``leftLayer``"
			assert (exists leftLayerSetup = outer.layerSetup(leftLayer));
			"No layer at index ``rightLayer``"
			assert (exists rightLayerSetup = other.layerSetup(rightLayer));
			value net = LayeredNeuralNetwork(
				//layers before
				outer.layersSetup.take(leftLayer)
				//merged layer
				.chain({leftLayerSetup.merge(rightLayerSetup)})
				//layers after
				.chain(outer.layersSetup.skip(leftLayer + 1)));
			
			{Synapse*} synapsesBefore =>
				//bias not included because shouldn't have synapses with inputs
				let (ll = outer.layer(leftLayer,false))
				let (rl = other.layer(rightLayer,false))
				ll.chain(rl)
				.flatMap((Neuron output) =>
					if (output in ll) then
						outer.synapsesTo(output)
					else
						other.synapsesTo(output));
			
			{Synapse*} synapsesAfter =>
				outer.layer(leftLayer + 1,false)
				.flatMap((Neuron output) =>
					{
						{
							outer.biasSynapseTo(output),
							other.biasSynapseTo(output)
						}
						.coalesced
						.reduce((Synapse partial, Synapse element) =>
							Synapse(
								partial.left,
								partial.right,
								partial.weight + element.weight))
					}
					.coalesced
					.chain(outer.synapsesTo(output,false)
					.chain(other.synapsesTo(output,false))));
					
			//for each link
			(0:net.links.size).each((Integer link) {
				value originalLink =
				//link to merged
				if (link == leftLayer - 1) then
					synapsesBefore
				//link from merged
				else if (link == leftLayer) then
					synapsesAfter
				else
					outer.link(link);
				net.update(
					zipEntries(
						net.link(link),
						originalLink*.weight));
			});
			return net;
		}
	}
		
	shared actual String string =>
		"\r\n".join(links);
	
}
