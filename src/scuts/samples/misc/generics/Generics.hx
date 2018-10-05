package scuts.samples.misc.generics;

import scuts.Prelude;

@:structInit class Bar {}

@:structInit class Yay {}

interface Printable<T> {
	public function print (t:T):String;
}

@:generic class PrintableBar implements Printable<Bar> implements ImplicitInstance {
	public function print (t:Bar):String {
		return "Bar";
	}
}

@:generic class PrintableYay implements Printable<Yay> implements ImplicitInstance {
	public function print (t:Yay):String {
		return "Yay";
	}
}


class App {
	public static function main () {
		var bar:Bar = {};
		var yay:Yay = {};
		printIt( bar );

		printIt( yay );

		// limitations partial application
		// printIt.bind(b)();
	}

	@:generic static function printIt <T>(p:T, ?P:Implicit<Printable<T>>) {
		trace(P.print(p));
	}
}