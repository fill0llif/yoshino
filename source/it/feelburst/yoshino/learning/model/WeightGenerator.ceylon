import it.feelburst.yoshino.model {
	Synapse
}
shared interface WeightGenerator {
	shared formal Float generate(Synapse synapse);
}