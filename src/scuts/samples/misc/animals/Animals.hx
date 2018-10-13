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

interface Animal<T> {}

class AnimalDog implements Animal<Dog> implements ImplicitInstance {}
class AnimalCat implements Animal<Cat> implements ImplicitInstance {}
class AnimalBird implements Animal<Bird> implements ImplicitInstance {}


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

interface AsBird<T> {
	public function get (x:T):Null<Bird>;
}

class AsBirdCat implements AsBird<Cat> implements ImplicitInstance {
	public inline function get (x:Cat):Null<Bird> return null;
}

class AsBirdDog implements AsBird<Dog> implements ImplicitInstance{
	public inline function get (x:Dog):Null<Bird> return null;
}

class AsBirdBird implements AsBird<Bird> implements ImplicitInstance {
	public inline function get (x:Bird):Null<Bird> return x;
}


enum AnimalObject {
	AnimalObject<T>(o:T, ?A:Implicit<Animal<T>>, ?B:Implicit<AsBird<T>>);
}

enum AnimalObject2 {
	AOCat(o:Cat);
	AOBird(o:Bird);
	AnimalObject2<T>(o:T, ?A:Implicit<Animal<T>>, ?B:Implicit<AsBird<T>>);
}


interface CAnimal {

}
@:structInit class CCat implements CAnimal {
	public var name : String;
}
@:structInit class CDog implements CAnimal {
	public var name : String;
}

@:structInit class CBird implements CAnimal {
	public var name : String;
	public var song : String;
}


@:structInit class AnimalDatabase {
	public var flyingAnimals:Array<AnimalObject>;
}


class App {

	static function test (b:Void->Void, msg:String, ?isWarmup:Bool = false) {
		var t = haxe.Timer.stamp();

		b();
		var msg = StringTools.rpad(msg, " ", 15);
		if (!isWarmup) {
			trace("time for " + msg + ": " + (haxe.Timer.stamp() - t));
		}
	}

	public static function main () {
		var bird:Bird = { name : "Jackie", song : "i belive i can fly" };

		var dog:Dog = { name : "Bello" };

		var cat:Cat =  { name : "Simba" };

		var cbird:CBird = { name : "Jackie", song : "i belive i can fly" };

		var cdog:CDog = { name : "Bello" };

		var ccat:CCat =  { name : "Simba" };

		var num = 900000;

		var birds = [for (i in 0...num) AnimalObject(bird)];
		var cats = [for (i in 0...num) AnimalObject(cat)];
		var dogs = [for (i in 0...num) AnimalObject(dog)];

		var animals = birds.concat(cats).concat(dogs);

		var birds2 = [for (i in 0...num) AOBird(bird)];
		var cats2 = [for (i in 0...num) AnimalObject2(cat)];
		var dogs2 = [for (i in 0...num) AnimalObject2(dog)];

		var animals2 = birds2.concat(cats2).concat(dogs2);

		var cbirds:Array<CAnimal> = [for (i in 0...num) cbird];
		var ccats:Array<CAnimal> = [for (i in 0...num) ccat];
		var cdogs:Array<CAnimal> = [for (i in 0...num) cdog];

		var canimals = cbirds.concat(ccats).concat(cdogs);

		test( () -> {
			var allSongs = [];
			for (e in animals){
				switch e {
					case AnimalObject(x, _, ab):
						var bird = ab.get(x);
						if (bird != null) {
							allSongs.push(bird.song);
						}
				}
			}
		}, "traits", true);


		test( () -> {
			var allSongs = [];
			for (e in animals){
				switch e {
					case AnimalObject(x, _, ab):
						var bird = ab.get(x);
						if (bird != null) {
							allSongs.push(bird.song);
						}
				}
			}
			trace(allSongs.length);
		}, "traits");

		test( () -> {
			var allSongs = [];
			for (e in animals2){
				switch e {
					case AnimalObject2(x, _, ab):
						var bird = ab.get(x);
						if (bird != null) {
							allSongs.push(bird.song);
						}
					case AOBird(b):
						allSongs.push(b.song);
					case AOCat(_):

				}
			}
			trace(allSongs.length);
		}, "traits opt");

		test( () -> {
			var allSongs = [];
			for (e in animals){
				switch e {
					case AnimalObject(x, _, ab):
						if (Std.is(x, Bird)) {
							var x = cast(x, Bird);
							allSongs.push(x.song);
						}
				}
			}
			trace(allSongs.length);
		}, "traits ugly");


		test( () -> {
			var allSongs = [];
			for (e in canimals){
				if (Std.is(e, CBird)) {
					var x = cast(e, CBird);
					allSongs.push(x.song);
				}
			}
			trace(allSongs.length);
		}, "classes");



	}
}

