shared final class LiveFloatValueInputReader(InputReader inputReader, Boolean splitting(Character ch) => ch.equals(',')) satisfies LiveValueInputReader<Float> {
	
	shared actual Float[] readValues() {
		if (exists line = inputReader.readLine()) {
			value rawValues = line.split(splitting);
			value values = rawValues.collect((String rawValue) {
					assert (is Float input = Float.parse(rawValue));
					return input;
				});
			return values;
		} else {
			return [];
		}
	}
	
	shared actual void close() => inputReader.close();
}
