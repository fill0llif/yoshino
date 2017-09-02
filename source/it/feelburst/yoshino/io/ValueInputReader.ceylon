shared interface ValueInputReader<Value>
	satisfies Destroyable
	given Value of String | Integer | Float {
	shared formal [Value*] readValues();
}
