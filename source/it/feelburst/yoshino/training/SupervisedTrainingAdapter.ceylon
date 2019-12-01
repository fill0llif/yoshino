import it.feelburst.yoshino.learning {
	SupervisedLearningRule
}
shared class SupervisedTrainingAdapter<Rule>()
	satisfies SupervisedTrainingListener<Rule>
	given Rule satisfies SupervisedLearningRule {
	
	shared default actual void beforeTraining(Rule rule) {}
	
	shared default actual void afterWeightsInitialization(
		Rule rule,
		[Float+]|[] weights) {}
	
	shared default actual void beforeEpoch(Rule rule) {}
	
	shared default actual void beforeWeightsUpdate(
		Rule rule, 
		{Float*} trainings, {Float*} targets,
		[Float+]|[] weights) {}
	
	shared default actual void afterWeightsUpdate(
		Rule rule,
		{Float*} trainings, {Float*} targets,
		[Float+]|[] weights) {}
	
	shared default actual void afterEpoch(Rule rule) {}
	
	shared default actual void afterTraining(Rule rule) {}
	
}