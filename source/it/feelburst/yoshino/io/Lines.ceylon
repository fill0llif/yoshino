import java.io {
	BufferedReader
}
shared class Lines(
	BufferedReader source())
	satisfies Iterable<String> {
	
	shared actual Iterator<String> iterator() =>
		object satisfies Iterator<String> {
			
			value source = outer.source();
			variable value exhausted = false;
			
			shared actual String|Finished next() {
				if (!exhausted,exists line = source.readLine()) {
					return line;
				}
				else {
					if (!exhausted) {
						source.close();
						exhausted = true;
					}
					return finished;
				}
			}
			
		};
	
}
