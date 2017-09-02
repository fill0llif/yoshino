import ceylon.random {
	DefaultRandom
}

import it.feelburst.yoshino.model.visitor {
	Visitable
}

shared class Synapse satisfies Visitable {
	shared Neuron left;
	shared Neuron right;
	shared variable Float weight;
	
	abstract new conn(Neuron left, Neuron right) {
		this.left = left;
		this.right = right;
	}
	
	shared new (Neuron lhs, Neuron rhs, Float weightInit() => DefaultRandom().nextFloat()) extends conn(lhs, rhs) {
		this.weight = weightInit();
	}
	
	shared new withWeight(Neuron lhs, Neuron rhs, Float weight = 0.0) extends conn(lhs, rhs) {
		this.weight = weight;
	}
	
	shared actual Boolean equals(Object that) {
		if (is Synapse that) {
			return left==that.left &&
					right==that.right;
		} else {
			return false;
		}
	}
	
	shared actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + left.hash;
		hash = 31*hash + right.hash;
		return hash;
	}
	
	shared actual String string => "(left=``left``,right=``right``,weight=``weight``)";
}
