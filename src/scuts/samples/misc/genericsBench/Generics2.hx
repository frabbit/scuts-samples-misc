package scuts.samples.misc.genericsBench;

import scuts.implicit.ImplicitGeneric;
import haxe.Timer;
import scuts.Prelude;

interface Plus<T> {
	public function plus (t:T, s:T):T;
}

interface Arithmetic<T> {
	var Plus(default,never):Plus<T>;
	function Plus1 (a:T, b:T):T;
}

@:funDeps(T->S) interface Arithmetic2<T,S:Plus<T>> {
	var Plus(default,null):S;
}

class Arithmetic2Float implements Arithmetic2<Float, PlusFloat>  implements ImplicitInstance {
	public final Plus:PlusFloat = PlusFloat.instance;
}

class PlusFloat implements Plus<Float>  {
	function new () {}
	public static final instance = new PlusFloat();
	public inline function plus (t1:Float, t2:Float):Float return t1 + t2;
}

@:generic @:final class ArithmeticFloat implements Arithmetic<Float> implements ImplicitInstance {
	final Plus:PlusFloat = PlusFloat.instance;
	inline function Plus1 (a:Float, b:Float):Float return Plus.plus(a, b);
}

class FastFloat {
	public function new () {}
	public inline function plus (t1:Float, t2:Float):Float return t1 + t2;
}

class App {
	static function test (b:Void->Void, msg:String) {
		var t = haxe.Timer.stamp();

		b();
		var msg = StringTools.rpad(msg, " ", 15);
		trace("time for " + msg + ": " + (Timer.stamp() - t));
	}
	public static function main () {

		trace("########## Benchmark Start ############");

		// warmup
		for (i in 0...100000) {
			//plusStatic(2.2, 2.7);
		}


		var loops = 10000000;
		var runs = 2;

		var q = 0.0;
		var ff = new FastFloat();

		for (i in 0...runs) {
			/*
			test(() -> {
				var acc = 0.0;
				for (i in 0...loops) {
					acc  += plusStatic(2.2, 2.7);
				}
				q = acc;
			}, "plusStatic");

			test(() -> {
				var acc = 0.0;
				var P = PlusFloat.instance;
				for (i in 0...loops) {
					acc += plusInstanceArg(2.2, 2.7, P);
				}
				q = acc;
			}, "plusInstanceArg");
			*/
			test(() -> {
				var acc = 0.0;
				acc += PlusFloat.instance.plus(1,2);
				for (i in 0...loops) {
					acc = acc + plusConstraint(2.2, 2.7, PlusFloat.instance);
				}
				q = acc;
			}, "plus2 ");
			/*
			test(() -> {
				var acc = 0.0;
				var P = PlusFloat.instance;
				$type(P);
				for (i in 0...loops) {
					acc += plus3(2.2, 2.7, P);
				}
				q = acc;
			}, "plus3 ");
			test(() -> {
				var acc = 0.0;
				for (i in 0...loops) {
					acc += plus7(2.2, 2.7);
				}
				q = acc;
			}, "plus7 ");
			test(() -> {
				var acc = 0.0;
				for (i in 0...loops) {
					acc += plus8(2.2, 2.7);
				}
				q = acc;
			}, "plus8 ");
			test(() -> {
				var acc = 0.0;
				for (i in 0...loops) {
					acc += plus9(2.2, 2.7);
				}
				q = acc;
			}, "plus9 ");
			test(() -> {
				var acc = 0.0;
				for (i in 0...loops) {
					acc += plus11(2.2, 2.7);
				}
				q = acc;
			}, "plus11 ");
			*/

		}
		trace("########## Benchmark End ############");

	}
	/*
	static inline function doPlus (a:Float, b:Float) {
		return a + b;
	}

	@:generic inline static function plusX <T,S:Plus<T>>(a:T, b:T, ?A:ImplicitGeneric<S, Plus<T>>) {
		return A.plus(a,b);
	}

	static inline function plusStatic (a:Float, b:Float) {
		return doPlus(a, b); // don't take inlining into account
	}



	static inline function plusInstanceArg (a:Float, b:Float, A:PlusFloat) {
		return A.plus(a, b); // don't take inlining into account
	}



	@:generic inline static function plus1 <T>(a:T, b:T, ?A:Implicit<Arithmetic<T>>) {
		return A.Plus.plus(a, b);
	}
	*/
	/*@:generic inline static function plusConstraint <T,S:Plus<T>>(a:T, b:T, ?A:ImplicitGeneric<S, Plus<T>>) {
		return A.plus(a, b);
	}*/

	inline static function plusConstraint <T,S:Plus<T>>(a:T, b:T, A:S) {
		return A.plus(a, b);
	}

	/*
	@:generic inline static function plus3 <T>(a:T, b:T, A:Plus<T>) {
		return A.plus(a, b);
	}

	@:generic inline static function plus7 <T,S:Arithmetic<T>>(a:T, b:T, ?A:ImplicitGeneric<S, Arithmetic<T>>) {
		return A.Plus.plus(a, b);
	}

	@:generic inline static function plus8 <T,S:Arithmetic<T>>(a:T, b:T, ?A:ImplicitGeneric<S, Arithmetic<T>>) {
		return A.Plus1(a,b);
	}

	@:generic inline static function plus9 <T,S:Arithmetic<T>>(a:T, b:T, ?A:ImplicitGeneric<S, Arithmetic<T>>) {
		return plusX(a,b);
	}

	@:generic inline static function plus11 <T,S:Arithmetic2<T,X>, X:Plus<T>>(a:T, b:T, ?A:ImplicitGeneric<S, Arithmetic2<T, X>>) {
		return A.Plus.plus(a,b);
	}
	*/


}