
shared final class ResourceInputReader(Resource resource, String encoding = "UTF-8") satisfies InputReader {
	value textContent = resource.textContent(encoding);
	function nextIndexOf(Integer from = 0) =>
		textContent.indexOf(operatingSystem.newline, from);
	variable value start = 0;
	variable value end = nextIndexOf();
	
	shared actual String? readLine() {
		if (end == -1) {
			return null;
		} else {
			value nextLine = textContent.substring(start, end);
			start = end + operatingSystem.newline.size;
			end =
				if (end == textContent.size) then -1
				else
					let (end = nextIndexOf(start))
					if (end == -1) then textContent.size
					else end;
			return nextLine;
		}
	}
	shared actual void close() {
		start = 0;
		end = nextIndexOf();
	}
}
