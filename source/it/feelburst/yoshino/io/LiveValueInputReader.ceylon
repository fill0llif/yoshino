shared interface LiveValueInputReader<Value>
		satisfies ValueInputReader<Value>
		given Value of String | Integer | Float {
	shared formal void close();
	shared actual void destroy(Throwable? error) {
		close();
		if (exists error) {
			throw error;
		}
	}
}