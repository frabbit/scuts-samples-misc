package scuts.samples.misc.clone;

import scuts.Prelude;

interface Clone<T> extends ApiDef {
	public function clone (t:T):T;
}

class CloneApi implements ApiOf<Clone<_>> {}

class CloneArray<T> implements Clone<Array<T>> implements ImplicitInstance {
	final cloneT:Clone<T>;

	function clone (a:Array<T>) {
		return [for (e in a) cloneT.clone(e)];
	}
}

class CloneInt implements Clone<Int> implements ImplicitInstance {
	inline function clone (a:Int) {
		return a;
	}
}

class App {
	public static function main () {
		trace(CloneApi.clone([1,2]));
	}
}