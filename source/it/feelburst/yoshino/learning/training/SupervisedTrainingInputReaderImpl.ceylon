import it.feelburst.yoshino.io {
	ValueInputReader
}

shared final class SupervisedTrainingInputReaderImpl(
	ValueInputReader<Float> reader,
	Boolean splitting(Character ch) => ch.equals(','))
		extends SupervisedTrainingInputReader<Float>(reader, splitting) {
	shared actual <[Float*]->[Float*]>? readTrainingPair(Integer input) =>
		if (nonempty values = reader.readValues()) then
			[*values.take(input)] -> [*values.skip(input)]
		else null;
}
