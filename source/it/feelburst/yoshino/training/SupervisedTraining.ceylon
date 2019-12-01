import it.feelburst.yoshino.learning {

	SupervisedLearningRule
}
shared interface SupervisedTraining<LearningRule>
	satisfies Training
	given LearningRule satisfies SupervisedLearningRule {
	shared formal SupervisedTrainingListener<LearningRule> listener;
}
