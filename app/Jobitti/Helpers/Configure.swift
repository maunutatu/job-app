func configure<T>(_ value: T, with closure: (inout T) -> Void) -> T {
	var value = value
	closure(&value)
	return value
}
