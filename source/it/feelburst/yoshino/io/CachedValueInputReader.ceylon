shared interface CachedValueInputReader<Value>
		satisfies ValueInputReader<Value>
		given Value of String | Integer | Float {
}