package scuts.samples.misc.specs;

import scuts.Prelude;
using scuts.data.Tuple;

/////////////////////////////////////////////////////////////////// Framework Code

// Some basic types

typedef Index = Int;

abstract Not<T, S>(T) {
	public inline function new (t) this = t;
	public inline function unwrap() return this;
}

//////////////// Storage

// abstract storage
interface Storage<S, C> extends ApiDef {
	public function get (s:S, id:Index):Null<C>;
	public function insert (s:S, id:Index, c:C):Void;
	public function remove (s:S, id:Index):Void;
	public function keys (s:S):Iterator<Index>;
}

// storage api can be used like StorageApi.get(storage, id);
class StorageApi implements ApiOf<Storage<_,_>> {}

// implicit shortcut for usage as constraint
typedef IStorage<S, C> = Implicit<Storage<S, C>>;

// simple storages

@:structInit class Unique<T> {
	public var val : Null<T>;
	public var index: Null<Index>;
}

typedef IndexMap<X> = Map<Index, X>;

class StorageIndexMap<T> implements Storage<IndexMap<T>, T> implements ImplicitInstance {
	inline function get (s:Map<Index, T>, id:Index):Null<T> {
		return s.get(id);
	}
	inline function insert (s:Map<Index, T>, id:Index, c:T):Void {
		s.set(id, c);
	}
	inline function remove (s:Map<Index, T>, id:Index):Void {
		s.remove(id);
	}
	inline function keys (s:Map<Index, T>):Iterator<Index> {
		return s.keys();
	}
}

class StorageUnique<T> implements Storage<Unique<T>, T> implements ImplicitInstance {

	inline function get (s:Unique<T>, id:Index):Null<T> {
		return s.val;
	}
	inline function insert (s:Unique<T>, id:Index, c:T):Void {
		s.index = id;
		s.val = c;
	}
	inline function remove (s:Unique<T>, id:Index):Void {
		if (id == s.index) {
			s.index =  null;
			s.val = null;
		}
	}
	inline function keys (s:Unique<T>):Iterator<Index> {
		return [s.index].iterator();
	}
}


//////////////// GetStorage

// GetStorage defines how to get the store from the world
// W = World, C = Component, S = Storage
@:funDeps((W, C) -> S) interface GetStorage<W, C, S> {
	var Component(default, null):Component<C, S>;
	function getStore(s:W):S;
}

typedef IGetStorage<W,C, S> = Implicit<GetStorage<W, C, S>>;

//////////////// Components

// a component is always associated with it's storage
@:funDeps(T -> StorageT) interface Component<T, StorageT> {}

typedef IComponent<T,S> = Implicit<Component<T, S>>;


class ComponentTup2<A,B, A1, B1> implements Component<Tup2<A,B>, Tup2<A1, B1>> implements ImplicitInstance {}
class ComponentNot<A,B, A1, B1> implements Component<Not<A,B>, Tup2<A1,B1>> implements ImplicitInstance {}
class ComponentTup3<A,B, C, A1, B1, C1> implements Component<Tup3<A,B,C>, Tup3<A1, B1, C1>> implements ImplicitInstance {}

///// Join

@:funDeps(Value -> Storage) interface Join<Storage, Value> extends ApiDef {
	function join (a:Storage):Iterator<Value>;
	function joinEach (a:Storage, f:Value->Void):Void;
	function keys (a:Storage):Iterator<Index>;
	function get (a:Storage, i:Index):Null<Value>;
}

typedef IJoin<A,B> = Implicit<Join<A,B>>;

class JoinApi implements ApiOf<Join<_,_>> {
	public inline static function getFor <Value, Storage>(_:scuts.data.TypeArg<Value>, ?J:IJoin<Storage, Value>) {
		return J;
	}
}

class JoinUnique<X> implements Join<Unique<X>, X> {
	public inline function get (a:Unique<X>, i:Index):Null<X> {
		return a.index != i ? null : a.val;
	}

	public inline function keys (a:Unique<X>):Iterator<Index> {
		return if (a.index != null) [a.index].iterator() else [].iterator();
	}

	public inline function join (a:Unique<X> ):Iterator<X> {
		return if (a.val != null) [a.val].iterator() else [].iterator();
	}

	public inline function joinEach (a:Unique<X>, f:X->Void):Void {
		if (a.val != null) f(a.val);
	}
}

class JoinMapIndex<X> implements Join<IndexMap<X>, X>  {
	public inline function get (a:IndexMap<X>, i:Index):Null<X> {
		return a.get(i);
	}

	public inline function keys (a:IndexMap<X>):Iterator<Index> {
		return a.keys();
	}

	public inline function join (a:IndexMap<X> ):Iterator<X> {
		return a.iterator();
	}

	public inline function joinEach (a:IndexMap<X>, f:X->Void):Void {
		for (e in a) f(e);
	}
}

class JoinNot<A, A1, B, B1> implements Join<Tup2<A, B>, Not<A1, B1>> implements ImplicitInstance {
	final joinA:Join<A, A1>;
	final joinB:Join<B, B1>;

	public inline function get (a:Tup2<A, B>, i:Index):Null<Not<A1,B1>> {
		var x1 = joinA.get(a._1(), i);
		var x2 = joinB.get(a._2(), i);
		return if (x2 != null) null else if (x1 != null) new Not(x1) else null;
	}
	public inline function keys (a:Tup2<A,B>):Iterator<Index> {
		return joinA.keys(a._1());
	}

	public inline function join (a:Tup2<A,B> ):Iterator<Not<A1,B1>> {
		var r = [];
		for (k in joinA.keys(a._1())) {
			switch get(a, k) {
				case null:
				case x: r.push(x);

			}
		}
		return r.iterator();
	}

	public inline function joinEach (a:Tup2<A,B>, f:Not<A1,B1>->Void):Void {
		for (k in joinA.keys(a._1())) {
			switch get(a, k) {
				case null:
				case x: f(x);

			}
		}
	}
}

class JoinTup2<A,B,C,D> implements Join<Tup2<A, B>, Tup2<C,D>> implements ImplicitInstance {

	final joinA:Join<A, C>;
	final joinB:Join<B, D>;

	inline function get (a:Tup2<A,B>, i:Index):Null<Tup2<C, D>> {
		var a1 = a._1();
		var a2 = a._2();
		var a = joinA.get(a1, i);
		var b = joinB.get(a2, i);
		return switch [a,b] {
			case [null, _]: null;
			case [_, null]: null;
			case [a, b]: Tup2(a, b);
		}
	}
	inline function keys (a:Tup2<A,B>):Iterator<Index> {
		return joinA.keys(a._1());
	}

	inline function join (a:Tup2<A,B> ):Iterator<Tup2<C, D>> {
		var r = [];
		for (k in joinA.keys(a._1())) {
			switch get(a, k) {
				case null:
				case x: r.push(x);

			}
		}
		return r.iterator();
	}

	inline function joinEach (a:Tup2<A,B>, f:Tup2<C,D>->Void):Void {
		for (k in joinA.keys(a._1())) {
			switch get(a, k) {
				case null:
				case x: f(x);

			}
		}
	}
}


class JoinTup3<A,B,C,A1,B1,C1> implements Join<Tup3<A, B, C>, Tup3<A1,B1,C1>> implements ImplicitInstance {

	final joinA:Join<A, A1>;
	final joinB:Join<B, B1>;
	final joinC:Join<C, C1>;

	inline function get (t:Tup3<A,B,C>, i:Index):Null<Tup3<A1, B1, C1>> {
		var a = joinA.get(t._1(), i);
		var b = joinB.get(t._2(), i);
		var c = joinC.get(t._3(), i);
		return switch [a, b, c] {
			case [null, _, _]: null;
			case [_, null, _]: null;
			case [a, b, c]: Tup3(a, b, c);
		}
	}
	inline function keys (a:Tup3<A,B,C>):Iterator<Index> {
		return joinA.keys(a._1());
	}

	inline function join (t:Tup3<A,B,C> ):Iterator<Tup3<A1, B1, C1>> {
		var r = [];
		for (k in joinA.keys(t._1())) {
			switch get(t, k) {
				case null:
				case x: r.push(x);
			}
		}
		return r.iterator();
	}

	inline function joinEach (a:Tup3<A,B,C>, f:Tup3<A1,B1,C1>->Void):Void {
		for (k in joinA.keys(a._1())) {
			switch get(a, k) {
				case null:
				case x: f(x);

			}
		}
	}
}



class ShowNot<A, B> implements Show<Not<A,B>> implements ImplicitInstance {
	@:implicit var showA:Show<A>;
	function show (p:Not<A,B>) {
		return "Not( " + showA.show(p.unwrap()) + ")";
	}
}

class ShowMap<K, V> implements Show<Map<K, V>> implements ImplicitInstance {

	@:implicit var showK:Show<K>;
	@:implicit var showV:Show<V>;

	function show (m:Map<K, V>) {
		var kv = [for (k in m.keys()) ShowApi.show(k) + " => " + ShowApi.show(m[k])];
		return "Map(" + kv.join(", ") +  ")";
	}
}


class GetStorageTup2<A,B,A1,B1> implements GetStorage<World, Tup2<A,B>, Tup2<A1, B1>> implements ImplicitInstance {
	final Component:ComponentTup2<A,B, A1, B1>;

	final getStoreA:GetStorage<World, A, A1>;
	final getStoreB:GetStorage<World, B, B1>;

	inline function getStore(w:World):Tup2<A1, B1> return Tup2(getStoreA.getStore(w), getStoreB.getStore(w));
}

class GetStorageNot<A,B,A1,B1> implements GetStorage<World, Not<A,B>, Tup2<A1, B1>> implements ImplicitInstance {
	final Component:ComponentNot<A,B, A1, B1>;

	final getStoreA:GetStorage<World, A, A1>;
	final getStoreB:GetStorage<World, B, B1>;

	inline function getStore(w:World):Tup2<A1, B1> return Tup2(getStoreA.getStore(w), getStoreB.getStore(w));
}

class GetStorageTup3<A,B,C,A1,B1,C1> implements GetStorage<World, Tup3<A,B,C>, Tup3<A1, B1, C1>> implements ImplicitInstance {
	final Component:ComponentTup3<A,B,C, A1, B1,C1>;

	final getStoreA:GetStorage<World, A, A1>;
	final getStoreB:GetStorage<World, B, B1>;
	final getStoreC:GetStorage<World, C, C1>;

	inline function getStore(w:World):Tup3<A1, B1,C1> return Tup3(getStoreA.getStore(w), getStoreB.getStore(w), getStoreC.getStore(w));
}



/////////////////////////////////////////////////////////////////// User Specific Code

@:structInit class Position {
	public var x : Float;
	public var y : Float;
}

@:structInit class Velocity {
	public var x : Float;
	public var y : Float;
}

// Hero is just a flag
abstract Hero(Int) { public inline function new () this = 0; }

typedef PositionStorage = IndexMap<Position>;
typedef VelocityStorage = IndexMap<Velocity>;
typedef HeroStorage = Unique<Hero>;

class JoinPosition<X> implements ImplicitInstance extends JoinMapIndex<Position> {}
class JoinVelocity<X> implements ImplicitInstance extends JoinMapIndex<Velocity> {}
class JoinHero<X> implements ImplicitInstance extends JoinUnique<Hero> {}


class ShowPosition<K, V> implements Show<Position> implements ImplicitInstance {
	function show (p:Position) {
		return "Position( " + p.x + ", " + p.y + ")";
	}
}
class ShowVelocity<K, V> implements Show<Velocity> implements ImplicitInstance {
	function show (p:Velocity) {
		return "Velocity( " + p.x + ", " + p.y + ")";
	}
}
class ShowHero<K, V> implements Show<Hero> implements ImplicitInstance {
	function show (p:Hero) {
		return "Hero";
	}
}

@:structInit class World {
	public var id : Index = 0;
	public var hero:HeroStorage;
	public var positions:PositionStorage;
	public var velocities:VelocityStorage;
}

class WorldApi {
	public static function join <C, S>(w:World, t:scuts.data.TypeArg<C>, ?GS:IGetStorage<World, C, S>, ?J:IJoin<S, C>) {
		return J.join(getStore(w, t));
	}

	public static function joinStore <C, S>(s:S, t:scuts.data.TypeArg<C>, ?J:IJoin<S, C>) {
		return J.join(s);
	}

	public static function getStore <C, S>(w:World, t:scuts.data.TypeArg<C>, ?GS:IGetStorage<World, C, S>) {
		return GS.getStore(w);
	}
	public static function createEntity<C, S>(w:World):Index {
		return w.id++;
	}
	public static function addComponent<C, S>(w:World, c:C, id:Index, ?GS:IGetStorage<World, C, S>, ?S:IStorage<S, C>) {
		S.insert(GS.getStore(w), id, c);
	}
}


class ShowWorld implements Show<World> implements ImplicitInstance {
	@:implicit var showPositions:Show<Map<Index, Position>>;
	@:implicit var showVelocities:Show<Map<Index, Velocity>>;

	function show (w:World) {
		return "{ id : " + w.id + ", positions: " + ShowApi.show(w.positions) + ", velocities: " + ShowApi.show(w.velocities) + " }";
	}
}

class GetStoragePosition implements GetStorage<World, Position, IndexMap<Position>> implements ImplicitInstance {
	final Component:ComponentPosition;
	public inline function getStore(w:World):Map<Int, Position> return w.positions;
}

class GetStorageVelocity implements GetStorage<World, Velocity, IndexMap<Velocity>> implements ImplicitInstance {
	final Component:ComponentVelocity;
	public inline function getStore(w:World):Map<Int, Velocity> return w.velocities;
}

class GetStorageHero implements GetStorage<World, Hero, Unique<Hero>> implements ImplicitInstance {
	final Component:ComponentHero;
	public inline function getStore(w:World):Unique<Hero> return w.hero;
}


// The component typeclass define how they are stored inside of the world

class ComponentPosition implements Component<Position, Map<Int, Position>> implements ImplicitInstance {}
class ComponentVelocity implements Component<Velocity, Map<Int, Velocity>> implements ImplicitInstance {}
class ComponentHero implements Component<Hero, Unique<Hero>> implements ImplicitInstance {}


class App {

	public static function main () {

		var w:World = {
			positions: new Map(),
			velocities: new Map(),
			hero: { val : null, index: null },
		};

		var p:Position = { x: 0.0, y: 0.0 };
		var v:Velocity = { x: 2.0, y: 2.0 };
		var p2:Position = { x: 0.0, y: 0.0 };
		var v2:Velocity = { x: 2.0, y: 2.0 };
		var h:Hero = new Hero();

		var entity1 = WorldApi.createEntity(w);
		var entity2 = WorldApi.createEntity(w);


		// register components
		WorldApi.addComponent(w, p, entity1);
		WorldApi.addComponent(w, v, entity1);
		WorldApi.addComponent(w, h, entity1);
		WorldApi.addComponent(w, p2, entity2);
		WorldApi.addComponent(w, v2, entity2);


		// Iteration/Join examples


		// iterate over all positions and velocities
		for (x in WorldApi.join(w, 'Tup2<Position, Velocity>')) {
			trace(ShowApi.show(x));
		}

		// iterate over all heroes
		for (x in WorldApi.join(w, 'Hero')) {
			trace(ShowApi.show(x));
		}

		// iterate over all positions and velocities
		for (x in WorldApi.join(w, 'Tup3<Hero, Position, Velocity>')) {
			trace(ShowApi.show(x));
		}


		// Not allows to filter all components from the second result from the first one

		for (x in WorldApi.join(w, 'Not<Tup2<Position, Velocity>, Hero>')) {
			trace(ShowApi.show(x));
		}



		trace(ShowApi.show(w));
	}

}

