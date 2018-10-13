package scuts.samples.misc.patternmatching;

import scuts.Prelude;

using scuts.samples.misc.patternmatching.Exprs.ExprApi;

class TypeBool {}
class TypeInt {}

@:structInit class Add<A,B> {
	public var a:A;
	public var b:B;
}
@:structInit class ConstInt {
	public var x:Int;
}
@:structInit class ConstString {
	public var x:Int;
}


@:funDeps(T->B) interface Eval<T,B> extends ApiDef {
	function eval (t:T):B;
}

@:funDeps( (A, B)->C) interface Plus<A,B,C> extends ApiDef {
	function plus (a:A, b:B):C;
}


class PlusIntInt implements Plus<Int, Int, Int> implements ImplicitInstance {
	function plus (a:Int, b:Int):Int return a + b;
}

class EvalConstInt implements Eval<ConstInt, Int> implements ImplicitInstance {
	function eval (t:ConstInt):Int return t.x;
}

class EvalAdd<X, Y, X1,Y1, Z> implements Eval<Add<X,Y>, Z> implements ImplicitInstance {
	final ex: Eval<X, X1>;
	final ey: Eval<Y, Y1>;
	final op: Plus<X1, Y1, Z>;

	function eval (t:Add<X, Y>):Z return op.plus( ex.eval(t.a), ey.eval(t.b) );
}

@:funDeps( (T1, T2) -> T3) interface ExprAdd<T1, T2, T3> extends ApiDef {
	function add (t1:T1, t2:T2):T3;
}

class ExprApi implements ApiOf<ExprAdd<_,_,_>> implements ApiOf<Eval<_,_>> {}

class ExprAddAdd<X, Y> implements ExprAdd<X, Y, Add<X, Y>> implements ImplicitInstance {

	function add (t1:X, t2:Y):Add<X, Y> {
		return { a: t1, b: t2 };
	}

}

class App {
	public static function main () {
		var c:ConstInt = { x : 1 };
		var added = c.add(c).add(c).add(c);

		trace(added.eval());
	}
}