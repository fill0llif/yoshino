shared interface SupervisedLearningRule satisfies LearningRule {
	shared formal void updateWeights({Float*} trainings, {Float*} targets);
}
