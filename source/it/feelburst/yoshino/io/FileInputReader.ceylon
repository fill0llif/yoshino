import ceylon.file {
	File
}


shared final class FileInputReader(File file) satisfies InputReader {
	
	value reader = file.Reader();
	
	shared actual String? readLine() =>
		reader.readLine();
	
	shared actual void close() =>
		reader.close();
}
