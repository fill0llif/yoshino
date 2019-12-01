import java.io {
	BufferedReader
}

shared final class SupervisedPairs(
	BufferedReader source(),
	Integer trainings,
	Boolean splitting(Character ch) => ch == ',')
	satisfies Iterable<{Float*}->{Float*}> {
	
	value splittedLines = SplittedLines(source,Float.parse,splitting);
	
	shared actual Iterator<{Float*}->{Float*}> iterator() =>
		object satisfies Iterator<{Float*}->{Float*}> {
			
			value iterator = splittedLines.iterator();
			
			shared actual <{Float*}->{Float*}>|Finished next() =>
				if (!is Finished values = iterator.next()) then
					values.take(outer.trainings) -> values.skip(outer.trainings)
				else
					finished;
				
		};
	
}
