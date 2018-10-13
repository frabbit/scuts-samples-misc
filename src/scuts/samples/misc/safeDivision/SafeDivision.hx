package scuts.samples.misc.safeDivision;

import scuts.Prelude;
import scuts.PreludeApi as P;

interface CanFail<F> {
	function or <A>():F<A>;
	function win <A>(a:A):F<A>;
}

class CanFailOption implements CanFail<Option<_>> implements ImplicitInstance {
	function or <A>():Option<A> return None;
	function win <A>(a:A):Option<A> return Some(a);
}

class Api {
	public static function safeDivision <Failable>(a:Float, b:Float, _:TypeArg<Failable>, ?CF:Implicit<CanFail<Failable>>):Failable<Float> {
		return if (b == 0.0) CF.or() else CF.win(a / b);
	}
}


class App {
	public static function main () {

		trace(P.show(Api.safeDivision(1, 0, 'Option<_>')));

		trace(P.show(Api.safeDivision(2, 2, 'Option<_>')));
	}
}