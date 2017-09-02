shared interface Visitable {
	shared void accept(Visitor visitor) =>
		visitor.visit(this);
}