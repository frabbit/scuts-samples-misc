package scuts.samples.misc.generics2;

import scuts.Prelude;

interface Plus<T> {
	public function plus (t:T, s:T):T;
}

interface Minus<T> {
	public function minus (t:T, s:T):T;
}

interface Arithmetic<T> {
	var Plus(default,null):Plus<T>;
	var Minus(default,null):Minus<T>;
}

@:generic class PlusInt implements Plus<Int> implements ImplicitInstance {
	public inline function plus (t1:Int, t2:Int):Int return t1 + t2;
}

@:generic class MinusInt implements Minus<Int> implements ImplicitInstance {
	public function minus (t1:Int, t2:Int):Int return t1 - t2;
}

@:generic class PlusFloat implements Plus<Float> implements ImplicitInstance {
	public inline function plus (t1:Float, t2:Float):Float return t1 + t2;
}

@:generic class MinusFloat implements Minus<Float> implements ImplicitInstance {
	public function minus (t1:Float, t2:Float):Float return t1 - t2;
}

@:generic class ArithmeticInt implements Arithmetic<Int> implements ImplicitInstance {
	final Plus = PlusInt.instance;
	final Minus = MinusInt.instance;

}
@:generic @:final class ArithmeticFloat implements Arithmetic<Float> implements ImplicitInstance {
	final Plus = PlusFloat.instance;
	final Minus = MinusFloat.instance;
	inline function Plus1 (a:Float, b:Float):Float return Plus.plus(a, b);
}


class App {

	public static function main () {
		plusMinus(2, 5);
		plusMinus(2.2, 2.7);
	}

	@:generic static function plusMinus <T>(a:T, b:T, ?A:Implicit<Arithmetic<T>>) {
		trace(A.Plus.plus(a, b));
		trace(A.Minus.minus(a, b));
	}

}