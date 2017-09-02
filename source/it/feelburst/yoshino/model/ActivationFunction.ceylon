import ceylon.numeric.float {
	e
}


shared abstract class ActivationFunction()
	of BinaryStep | BipolarStep | Sign | UndecidedBand | Linear | identity | Sigmoid | BipolarSigmoid | hyperbolicTangent {
	shared formal Float apply(Float input);
}

shared class BinaryStep(Float threshold = 0.0) extends ActivationFunction() {
	shared actual Float apply(Float input) =>
		if (input < threshold) then 0.0
		else 1.0;
}
shared class BipolarStep(Float threshold = 0.0) extends ActivationFunction() {
	shared actual Float apply(Float input) =>
		if (input < threshold) then -1.0
		else 1.0;
}
shared class Sign(Float threshold = 0.0) extends ActivationFunction() {
	shared actual Float apply(Float input) =>
		if (input < threshold) then -1.0
		else if (input > threshold) then 1.0
		else 0.0;
}
shared class UndecidedBand(Float threshold) extends ActivationFunction() {
	assert (threshold >= 0.0);
	shared actual Float apply(Float input) =>
		if (input < -threshold) then -1.0
		else if (input > threshold) then 1.0
		else 0.0;
}
shared class Linear(Float slope = 1.0,Float origin = 0.0) extends ActivationFunction() {
	shared actual Float apply(Float input) => origin + slope * input;
}
shared class Sigmoid(Float steepness = 1.0) extends ActivationFunction() {
	assert (steepness > 0.0);
	shared actual Float apply(Float input) =>
		1.0 / (1.0 + e^(steepness * input));
}
shared class BipolarSigmoid(Float steepness = 1.0) extends ActivationFunction() {
	assert (steepness > 0.0);
	shared actual Float apply(Float input) =>
		(1.0 - e^(-steepness * input)) / (1.0 + e^(-steepness * input));
}
shared object identity extends ActivationFunction() {
	shared actual Float apply(Float input) => Linear().apply(input);
}
shared object hyperbolicTangent extends ActivationFunction() {
	shared actual Float apply(Float input) => BipolarSigmoid(2.0).apply(input);
}
