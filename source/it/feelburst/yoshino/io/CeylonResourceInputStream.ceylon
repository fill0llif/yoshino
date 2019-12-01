import java.io {
	InputStream
}
import java.util.zip {
	ZipFile
}
shared class CeylonResourceInputStream(Resource resource)
	extends InputStream() {
	
	value car = ZipFile(
		String(resource.uri
			.removeInitial("classpath:/")
				.takeWhile((Character char) =>
			char != '!')));
	value inputStream =
		let (file = car.getEntry(
			resource.uri.substring(resource.uri.indexOf("!") + 1)))
		car.getInputStream(file);
	
	shared actual Integer read() =>
		inputStream.read();
	
	shared actual Integer available() =>
		inputStream.available();
	
	shared actual void mark(Integer readlimit) =>
		inputStream.mark(readlimit);
	
	shared actual Boolean markSupported() =>
		inputStream.markSupported();
	
	shared actual Integer skip(Integer n) =>
		inputStream.skip(n);
	
	shared actual void reset() =>
		inputStream.reset();
	
	shared actual void close() {
		inputStream.close();
		car.close();
	}
	
}