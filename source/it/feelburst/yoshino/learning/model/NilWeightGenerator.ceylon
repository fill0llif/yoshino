import it.feelburst.yoshino.model {
	Synapse
}

shared final class NilWeightGenerator()
	satisfies WeightGenerator {
	shared actual Float generate(Synapse synapse) =>
		0.0;
}