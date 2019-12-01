import ceylon.language.meta {
	typeLiteral
}

import java.io {
	BufferedReader
}
shared class SplittedLines<Type>(
	BufferedReader source(),
	Type|Exception parse(String val),
	Boolean splitting(Character ch) => ch == ',')
	satisfies Iterable<{Type*}>
	given Type satisfies Object {
	
	value lines = Lines(source);
	
	shared actual Iterator<{Type*}> iterator() =>
		object satisfies Iterator<{Type*}> {
		
			value iterator = lines.iterator();
			
			shared actual {Type*}|Finished next() {
				if (!is Finished line = iterator.next()) {
					return line
						.split(splitting)
						.map((String val) {
							"Value ``val`` cannot be parsed to type ``typeLiteral<Type>()``"
							assert (is Type prsdVal = parse(val));
							return prsdVal;
						});
				}
				else {
					return finished;
				}
			}
		};
	
}