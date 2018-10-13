package scuts.samples.misc.existentials;

import scuts.Prelude;


interface HasSize<T> extends ApiDef {
	public function size(t:T):Int;
}

class HasSizeApi implements ApiOf<HasSize<_>> {}

enum Sized {
	Sized<T>(t:T, ?H:Implicit<HasSize<T>>);
}


class HasSizeFloat implements HasSize<Float> implements ImplicitInstance {
	public inline function size(t:Float):Int return 64;
}

class HasSizeInt implements HasSize<Int> implements ImplicitInstance {
	public inline function size(t:Int):Int return 32;
}

class HasSizeSized implements HasSize<Sized> implements ImplicitInstance {
	public inline function size(t:Sized):Int return switch t {
		case Sized(t, h): h.size(t);
	};
}



class App {

	public static function main () {
		var a = [Sized(1), Sized(1.1)];

		for (e in a) {
			trace(HasSizeApi.size(e));
		}

	}
}

