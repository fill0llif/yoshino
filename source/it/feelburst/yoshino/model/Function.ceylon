import ceylon.numeric.float {
	e,
	log,
	pi
}

shared abstract class Function() satisfies Exponentiable<Function,Function> {
	shared formal Float apply(Float input);
	shared default Function derivative {
		throw Exception("Function has no derivative");
	}
	shared default actual Function plus(Function other) =>
		Addition(this,other);
	shared default actual Function negated =>
		Negation(this);
	shared default actual Function times(Function other) =>
		Product(this,other);
	shared default actual Function divided(Function other) =>
		Division(this,other);
	shared default actual Function power(Function other) =>
		Power(this,other);
}

shared class Addition(
	Function lhs,
	Function rhs)
	extends Function() {
	shared actual Float apply(Float input) =>
		lhs.apply(input) + rhs.apply(input);
	shared actual Function derivative =>
		lhs.derivative + rhs.derivative;
	shared actual String string =>
		"``lhs`` + ``rhs``";
}

shared class Negation(
	Function fnctn)
	extends Function() {
	shared actual Float apply(Float input) =>
		-fnctn.apply(input);
	shared actual Function derivative =>
		-fnctn.derivative;
	shared actual String string =>
		"``-fnctn``";
}

shared class Product(
	Function lhs,
	Function rhs)
	extends Function() {
	shared actual Float apply(Float input) =>
		lhs.apply(input) * rhs.apply(input);
	shared actual Function derivative =>
		lhs.derivative * rhs + lhs * rhs.derivative;
	shared actual String string =>
		let (prdcts = {
			(Function fnctn) => fnctn is Constant,
			(Function fnctn) => fnctn == identity,
			(Function fnctn) => fnctn is Ln,
			(Function fnctn) => fnctn is Power
		})
		if (prdcts.any((Boolean(Function) prdct) =>
				prdct(lhs)),
			prdcts.any((Boolean(Function) prdct) =>
				prdct(rhs))) then
			"``lhs`` * ``rhs``"
		else if (prdcts.any((Boolean(Function) prdct) =>
			prdct(lhs))) then
			"``lhs`` * (``rhs``)"
		else if (prdcts.any((Boolean(Function) prdct) =>
			prdct(rhs))) then
			"(``lhs``) * ``rhs``"
		else
			"(``lhs``) * (``rhs``)";
}

shared class Division(
	Function lhs,
	Function rhs)
	extends Function() {
	shared actual Float apply(Float input) {
		value divisor = rhs.apply(input);
		if (divisor != 0.0) {
			return lhs.apply(input) / divisor;
		}
		else {
			throw Exception("Cannot divide by zero");
		}
	}
	shared actual Function derivative =>
		(lhs.derivative * rhs - lhs * rhs.derivative) /
		(rhs ^ Constant(2.0));
	shared actual String string =>
		let (prdcts = {
			(Function fnctn) => fnctn is Constant,
			(Function fnctn) => fnctn == identity,
			(Function fnctn) => fnctn is Ln,
			(Function fnctn) => fnctn is Power
		})
		if (prdcts.any((Boolean(Function) prdct) =>
				prdct(lhs)),
			prdcts.any((Boolean(Function) prdct) =>
				prdct(rhs))) then
			"``lhs`` / ``rhs``"
		else if (prdcts.any((Boolean(Function) prdct) =>
			prdct(lhs))) then
			"``lhs`` / (``rhs``)"
		else if (prdcts.any((Boolean(Function) prdct) =>
			prdct(rhs))) then
			"(``lhs``) / ``rhs``"
		else
			"(``lhs``) / (``rhs``)";
}

shared class Power(
	Function lhs,
	Function rhs)
	extends Function() {
	shared actual Float apply(Float input) =>
		lhs.apply(input) ^ rhs.apply(input);
	shared actual Function derivative =>
		this * (rhs / lhs * lhs.derivative + Ln(lhs) * rhs.derivative);
	shared actual String string =>
		let (prdcts = {
			(Function fnctn) => fnctn is Constant,
			(Function fnctn) => fnctn == identity,
			(Function fnctn) => fnctn is Ln})
		if (prdcts.any((Boolean(Function) prdct) =>
				prdct(lhs)),
			prdcts.any((Boolean(Function) prdct) =>
				prdct(rhs))) then
			"``lhs`` ^ ``rhs``"
		else if (prdcts.any((Boolean(Function) prdct) =>
			prdct(lhs))) then
			"``lhs`` ^ (``rhs``)"
		else if (prdcts.any((Boolean(Function) prdct) =>
			prdct(rhs))) then
			"(``lhs``) ^ ``rhs``"
		else
			"(``lhs``) ^ (``rhs``)";
}

"f(x) = a + ib"
shared class Complex(
	shared Float real,
	shared Float imaginary)
	extends Function() {
	shared actual Float apply(Float input) =>
		real;
	shared actual Function derivative =>
		Constant(0.0);
	shared default actual Boolean equals(Object that) {
		if (is Complex that) {
			return real==that.real && 
				imaginary==that.imaginary;
		}
		else {
			return false;
		}
	}
	shared default actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + real.hash;
		hash = 31*hash + imaginary.hash;
		return hash;
	}
	shared default actual String string =>
		"``real`` + i * ``imaginary``";
}

"f(x) = k"
shared class Constant(shared Float k)
	extends Complex(k,0.0) {
	shared actual Boolean equals(Object that) {
		if (is Constant that) {
			return super.equals(that);
		}
		else {
			return false;
		}
	}
	shared actual String string =>
		"``k``";
}

"f(x) =
 (0.0, x < threshold OR 
 1.0, x >= threshold)"
shared class BinaryStep(shared Float threshold = 0.0)
	extends Function() {
	shared actual Float apply(Float input) =>
		if (input < threshold) then 0.0
		else 1.0;
	shared actual Boolean equals(Object that) {
		if (is BinaryStep that) {
			return threshold==that.threshold;
		}
		else {
			return false;
		}
	}
	shared actual Integer hash =>
		threshold.hash;
	shared actual String string =>
		"0.0, x < ``threshold``
		 1.0, x >= ``threshold``";
}

"f(x) = 
 (-1.0, x < threshold OR 
 1.0, x >= threshold)"
shared class BipolarStep(shared Float threshold = 0.0)
	extends Function() {
	shared actual Float apply(Float input) =>
		if (input < threshold) then -1.0
		else 1.0;
	shared actual Boolean equals(Object that) {
		if (is BipolarStep that) {
			return threshold==that.threshold;
		}
		else {
			return false;
		}
	}
	shared actual Integer hash =>
		threshold.hash;
	shared actual String string =>
		"-1.0, x < ``threshold``
		 1.0, x >= ``threshold``";
}

"f(x) = 
 (-1.0, x < threshold OR 
 0.0, x = threshold OR 
 1.0, x > threshold)"
shared class Sign(shared Float threshold = 0.0)
	extends Function() {
	shared actual Float apply(Float input) =>
		if (input < threshold) then -1.0
		else if (input > threshold) then 1.0
		else 0.0;
	shared actual Boolean equals(Object that) {
		if (is Sign that) {
			return threshold==that.threshold;
		}
		else {
			return false;
		}
	}
	shared actual Integer hash =>
		threshold.hash;
	shared actual String string =>
		"-1.0, x < ``threshold``
		 0.0, x = ``threshold``
		 1.0, x > ``threshold``";
}

"f(x) = 
 (-1.0, x < -threshold OR
 0.0, -threshold > x > threshold OR
 1.0, x > threshold)"
shared class UndecidedBand(shared Float threshold)
	extends Function() {
	assert (threshold >= 0.0);
	shared actual Float apply(Float input) =>
		if (input < -threshold) then -1.0
		else if (input > threshold) then 1.0
		else 0.0;
	shared actual Boolean equals(Object that) {
		if (is UndecidedBand that) {
			return threshold==that.threshold;
		}
		else {
			return false;
		}
	}
	shared actual Integer hash =>
		threshold.hash;
	shared actual String string =>
		"-1.0, x < ``-threshold``
		 0.0, ``-threshold`` > x > ``threshold``
		 1.0, x > ``threshold``";
}

"f(x) = x"
shared object identity extends Function() {
	shared actual Float apply(Float input) =>
		input;
	shared actual Function derivative =>
		Constant(1.0);
	shared actual String string =>
		"x";
}

"f(x) = m * g(x) + k"
shared class Linear(
	shared Float slope = 1.0,
	shared Float origin = 0.0,
	shared Function fnctn = identity)
	extends Function() {
	shared actual Float apply(Float input) =>
		origin + slope * fnctn.apply(input);
	shared actual Function derivative =>
		Constant(slope) * fnctn.derivative;
	shared actual Boolean equals(Object that) {
		if (is Linear that) {
			return slope==that.slope && 
				origin==that.origin && 
				fnctn==that.fnctn;
		}
		else {
			return false;
		}
	}
	shared actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + slope.hash;
		hash = 31*hash + origin.hash;
		hash = 31*hash + fnctn.hash;
		return hash;
	}
	shared actual String string =>
		"``slope`` * ``if (fnctn == identity) then "x" else "(``fnctn``)"`` " +
		"``if (origin >= 0.0) then
			"+ ``origin``"
		else
			"- ``origin.negated``"``";
}

"f(x) = g(x) / h(x)"
shared class Rational(
	shared Function numerator,
	shared Function denominator)
	extends Function() {
	value rational = numerator / denominator;
	shared actual Float apply(Float input) =>
		rational.apply(input);
	shared actual Function derivative =>
		rational.derivative;
	shared actual Boolean equals(Object that) {
		if (is Rational that) {
			return numerator==that.numerator && 
				denominator==that.denominator;
		}
		else {
			return false;
		}
	}
	shared actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + numerator.hash;
		hash = 31*hash + denominator.hash;
		return hash;
	}
	shared actual String string =>
		rational.string;
}

"f(x) = 1 / g(x)"
shared class Reciprocal(
	shared Function fnctn = identity)
	extends Rational(
		Constant(1.0),
		fnctn) {}

"f(x) = ln(g(x))"
shared class Ln(Function fnctn = identity)
	extends Function() {
	shared actual Float apply(Float input) {
		value val = fnctn.apply(input);
		if (val > 0.0) {
			return log(val);
		}
		else if (val < 0.0) {
			return Complex(log(-val),pi).apply(input);
		}
		else {
			throw Exception(
				"Logarithm's argument may be only positive or " +
				"negative (as a complex constant with ln(-real) + i\{#03C0}, real < 0");
		}
	}
	shared actual Function derivative =>
		Reciprocal(fnctn) * fnctn.derivative;
	shared actual Boolean equals(Object that) {
		if (is Ln that) {
			return fnctn==that.fnctn;
		}
		else {
			return false;
		}
	}
	shared actual Integer hash =>
		fnctn.hash;
	shared actual String string =>
		"ln(``fnctn``)";
}

"f(x) = e ^ g(x)"
shared class E(Function fnctn = identity)
	extends Function() {
	shared actual Float apply(Float input) =>
		e ^ fnctn.apply(input);
	shared actual Function derivative =>
		(Constant(e) ^ fnctn) * fnctn.derivative;
	shared actual Boolean equals(Object that) {
		if (is E that) {
			return fnctn==that.fnctn;
		}
		else {
			return false;
		}
	}
	shared actual Integer hash =>
		fnctn.hash;
	shared actual String string =>
		let (prdcts = {
			(Function fnctn) => fnctn is Constant,
			(Function fnctn) => fnctn == identity,
			(Function fnctn) => fnctn is Ln
		})
		"e ^ ``if (prdcts.any((Boolean(Function) prdct) => prdct(fnctn))) then
			"``fnctn``"
		else
			"(``fnctn``)"``";
}

"f(x) = 1 / (1 + e ^ (-steepness * x))"
shared class Sigmoid(shared Float steepness = 1.0)
	extends Reciprocal(Linear(1.0,1.0,E(Linear(-steepness)))) {
	assert (steepness > 0.0);
}

"f(x) = (1 - e^(-steepness * x)) / (1 + e^(-steepness * x))"
shared class BipolarSigmoid(shared Float steepness = 1.0)
	extends Rational(
		Linear(-1.0,1.0,E(Linear(-steepness))),
		Linear(1.0,1.0,E(Linear(-steepness)))) {
	assert (steepness > 0.0);
}

"f(x) = (1 - e^(-2 * steepness * x)) / (1 + e^(-2 * steepness * x))"
shared class HyperbolicTangent(Float steepness = 1.0)
	extends BipolarSigmoid(2.0 * steepness) {}

"f(x) = ln(1 + e^(steepness * x))"
shared class Softplus(shared Float steepness = 1.0)
	extends Ln(Linear(1.0,1.0,E(Linear(steepness)))) {
	assert (steepness > 0.0);
}

"f(x) =
 (-ln(1 - x), x < 0 OR
 ln(1 + x), x >= 0)"
shared object logOf1PlusMinusX extends Function() {
	value logOf1PlusX = Ln(Linear(1.0,1.0));
	value minusLogOf1MinusX = -Ln(Linear(-1.0,1.0));
	shared actual Float apply(Float input) =>
		if (input >= 0.0) then
			logOf1PlusX.apply(input)
		else
			minusLogOf1MinusX.apply(input);
	shared actual Function derivative =>
		object extends Function() {
			shared actual Float apply(Float input) =>
				if (input >= 0.0) then
					logOf1PlusX.derivative.apply(input)
				else
					minusLogOf1MinusX.derivative.apply(input);
		};
	shared actual String string =>
		"-ln(1 - x), x < 0
		 ln(1 + x), x >= 0";
}

shared object relu extends Function() {
	shared actual Float apply(Float input) =>
		max({0.0,input});
	shared actual Function derivative =>
		BinaryStep();
	shared actual String string =>
		"max(0,x)";
}
