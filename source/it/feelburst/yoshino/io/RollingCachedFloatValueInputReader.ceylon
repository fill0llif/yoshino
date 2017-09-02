shared final class RollingCachedFloatValueInputReader(InputReader inputReader, Boolean splitting(Character ch) => ch.equals(',')) satisfies CachedValueInputReader<Float> {
	
	value valueInputReader = LiveFloatValueInputReader(inputReader);
	variable value exhausted = false;
	variable [[Float*]*] cachedValues = [];
	variable value index = 0;
	
	shared actual Float[] readValues() {
		if (exhausted) {
			if (exists values = cachedValues[index]) {
				index++;
				return values;
			} else {
				index = 0;
				return [];
			}
		} else {
			if (nonempty values = valueInputReader.readValues()) {
				cachedValues = cachedValues.withTrailing(values);
				return values;
			} else {
				exhausted = true;
				valueInputReader.close();
				return [];
			}
		}
	}
	
	shared actual void destroy(Throwable? error) {
		if (!exhausted) {
			valueInputReader.close();
		}
		if (exists error) {
			throw error;
		}
	}
}