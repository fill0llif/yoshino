import it.feelburst.yoshino.model {
	Synapse,
	NeuralNetwork,
	Neuron
}

shared class NetInputVisitor(Neuron to)
	satisfies Visitor {
	
	shared variable Float netInput = 0.0;
	shared actual void visit(Visitable visitable) {
		if (is NeuralNetwork visitable) {
			visitable
			.synapsesTo(to)
			.each((Synapse synapse) =>
				synapse.accept(this));
		} else if (is Synapse visitable) {
			value netInputPartial = visitable.left.output * visitable.weight;
			netInput += netInputPartial;
		} else {}
	}
}
