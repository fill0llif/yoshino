import it.feelburst.yoshino.learning {
	SupervisedLearningRule
}
shared interface SupervisedTrainingListener<LearningRule>
	given LearningRule satisfies SupervisedLearningRule {
	shared formal void beforeTraining(LearningRule rule);
	shared formal void afterWeightsInitialization(
		LearningRule rule,
		[Float+]|[] weights);
	shared formal void beforeEpoch(LearningRule rule);
	shared formal void beforeWeightsUpdate(
		LearningRule rule,
		{Float*} trainings, {Float*} targets,
		[Float+]|[] weights);
	shared formal void afterWeightsUpdate(
		LearningRule rule,
		{Float*} trainings, {Float*} targets,
		[Float+]|[] weights);
	shared formal void afterEpoch(LearningRule rule);
	shared formal void afterTraining(LearningRule rule);
}
