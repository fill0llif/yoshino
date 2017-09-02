shared interface InputReader satisfies Destroyable {
	shared formal String? readLine();
	shared formal void close();
	shared actual void destroy(Throwable? error) {
		close();
		if (exists error) {
			throw error;
		}
	}
}
