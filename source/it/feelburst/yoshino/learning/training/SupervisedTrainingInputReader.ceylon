import it.feelburst.yoshino.io {
	ValueInputReader,
	LiveValueInputReader
}

shared abstract class SupervisedTrainingInputReader<Value>(ValueInputReader<Value> reader, Boolean splitting(Character ch) => ch.equals(','))
	satisfies Destroyable
	given Value of String|Integer|Float {
	shared formal <[Value*]->[Value*]>? readTrainingPair(Integer input);
	shared actual void destroy(Throwable? error) {
		if (is LiveValueInputReader<Value> reader) {
			reader.close();
		}
		if (exists error) {
			throw error;
		}
	}
}
