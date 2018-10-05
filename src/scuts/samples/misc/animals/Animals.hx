package scuts.samples.misc.animals;

import scuts.Prelude;

@:structInit class Dog {
	public var name : String;
}
@:structInit class Cat {
	public var name : String;
}
@:structInit class Bird {
	public var name : String;
	public var song : String;
}


interface Fly<T> extends ApiDef {
	public function fly (t:T):Void;
}
class FlyApi implements ApiOf<Fly<_>> {}

class FlyBird implements Fly<Bird> implements ImplicitInstance {
	public function fly (t:Bird) {
		trace("Fly " + t.name + " to song " + t.song);
	}
}

interface Say<T> extends ApiDef {
	public function say (t:T):Void;
}
class SayApi implements ApiOf<Say<_>> {}

class SayBird implements Say<Bird> implements ImplicitInstance {
	public function say (t:Bird) {
		trace("i'm a bird");
	}
}


enum FlyObject {
	FlyObject<T>(o:T, ?f:Implicit<Fly<T>>);
}

@:structInit class AnimalDatabase {
	public var flyingAnimals:Array<FlyObject>;
}


class App {

	static function main () {
		var bird:Bird = { name : "jackie", song : "i belive i can fly" };

		FlyApi.fly(bird);


		var flyObject:FlyObject = FlyObject(bird);

		withFlyObject(flyObject);
	}

	static function withFlyObject (f:FlyObject) {
		switch f {
			case FlyObject(o, f): FlyApi.fly(o);
		}
	}
}

