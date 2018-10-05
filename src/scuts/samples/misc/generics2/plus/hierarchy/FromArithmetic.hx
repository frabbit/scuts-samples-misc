package scuts.samples.misc.generics2.plus.hierarchy;

import scuts.samples.misc.generics2.Generics2;

class FromArithmetic {
	@:implicit @:generic public static inline function fromArithmetic <T>(a:Arithmetic<T>):Plus<T> return a.Plus;
}