package scuts.samples.misc.def;

import scuts.Prelude;

interface Default<T> {
	public function get ():T;
}

class DefaultString implements Default<String> implements ImplicitInstance {
	public function get ():String return "default_string";
}

typedef IDefault<T> = Implicit<Default<T>>;

class DefaultApi {
	public function get <T>(_:Proxy<T>, ?D:IDefault<T>):T return D.get();
}


class Options {
	public static function getOrDefault<T>(o:Option<T>, ?D:IDefault<T>):T {
		return switch o {
			case Some(x):x;
			case None: D.get();
		}
	}
}

class App {
	public static function main () {
		trace(Options.getOrDefault(Some("hello world")));
		trace(Options.getOrDefault((None:Option<String>)));
	}


}