shared interface SupervisedLearningRule satisfies LearningRule {
	shared formal void updateWeights([Float*] training, [Float*] target);
}
