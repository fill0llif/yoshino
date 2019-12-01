import ceylon.random {
	DefaultRandom
}

import it.feelburst.yoshino.model {
	Synapse
}
shared final class RandomWeightGenerator(Float min,Float max)
	satisfies WeightGenerator {
	assert (min < max);
	value random = DefaultRandom();
	shared actual Float generate(Synapse synapse) =>
		min + (random.nextFloat() * (max - min));
}