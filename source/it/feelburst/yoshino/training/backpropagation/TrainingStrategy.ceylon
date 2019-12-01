import java.io {

	BufferedReader
}
import it.feelburst.yoshino.model {

	Function
}
shared interface TrainingStrategy {
	shared formal BufferedReader trainingInputReader();
	shared formal Boolean isTrainingDone();
	shared formal Function loss(Float target);
}
