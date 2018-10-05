package scuts.samples.misc.genericsBench.plus.hierarchy;

import scuts.samples.misc.genericsBench.Generics2;

class FromArithmetic {
	@:implicit @:generic public static inline function fromArithmetic <T>(a:Arithmetic<T>):Plus<T> return a.Plus;
}