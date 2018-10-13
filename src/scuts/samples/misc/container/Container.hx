package scuts.samples.misc.container;

import haxe.ds.StringMap;
import haxe.ds.IntMap;
import scuts.Prelude;

interface Filter<F> extends ApiDef {
	function filter <A>(fa:F<A>, fn:A->Bool):F<A>;
}

interface HasElem<F> extends ApiDef {
	function hasElem <A>(fa:F<A>, elem:A, ?E:IEq<A>):Bool;
}

interface ForEach<F> extends ApiDef {
	function forEach <A>(fa:F<A>, f:A->Void):Void;
}


interface Mappable<F> extends ApiDef {
	function map <A,B>(fa:F<A>, f:A->B):F<B>;
}

@:funDeps(F->K) interface MappableWithKey<F,K> extends ApiDef {
	function mapWithKey <A,B>(fa:F<A>, f:K->A->B):F<B>;
}

class ContainerApi implements ApiOf<Filter<_>> implements ApiOf<HasElem<_>> implements ApiOf<ForEach<_>> implements ApiOf<Mappable<_>> implements ApiOf<MappableWithKey<_,_>> {}


class FilterArray implements Filter<Array<_>> implements ImplicitInstance {
	public function filter <A>(fa:Array<A>, fn:A->Bool):Array<A> {
		return fa.filter(fn);
	}
}

class MappableArray implements Mappable<Array<_>> implements ImplicitInstance {
	public function map <A,B>(fa:Array<A>, f:A->B):Array<B> {
		return fa.map(f);
	}
}


class MappableWithKeyArray implements MappableWithKey<Array<_>, Int> implements ImplicitInstance {
	public function mapWithKey <A,B>(fa:Array<A>, f:Int->A->B):Array<B> {
		return [for (i in 0...fa.length) f(i, fa[i])];
	}
}

class HasElemArray implements HasElem<Array<_>> implements ImplicitInstance {
	public function hasElem <A>(fa:Array<A>, elem:A, ?E:IEq<A>):Bool {
		for (e in fa) {
			if (E.eq(e, elem)) return true;
		}
		return false;
	}
}

class ForEachArray implements ForEach<Array<_>> implements ImplicitInstance {
	public function forEach <A>(fa:Array<A>, f:A->Void):Void {
		for (e in fa) f(e);
	}
}

//// StringMap

class FilterStringMap implements Filter<StringMap<_>> implements ImplicitInstance {
	public function filter <A>(fa:StringMap<A>, fn:A->Bool):StringMap<A> {
		return [
			for (k in fa.keys()) if (fn(fa.get(k))) k => fa.get(k)
		];
	}
}

class ForEachStringMap implements ForEach<StringMap<_>> implements ImplicitInstance {
	public function forEach <A>(fa:StringMap<A>, f:A->Void):Void {
		for (e in fa) f(e);
	}
}

class MappableWithKeyStringMap implements MappableWithKey<StringMap<_>, String> implements ImplicitInstance {
	public function mapWithKey <A,B>(fa:StringMap<A>, f:String->A->B):StringMap<B> {
		return [
			for (k in fa.keys()) k => f(k, fa.get(k))
		];
	}
}

/// IntMap

class ForEachIntMap implements ForEach<IntMap<_>> implements ImplicitInstance {
	public function forEach <A>(fa:IntMap<A>, f:A->Void):Void {
		for (e in fa) f(e);
	}
}

class FilterIntMap implements Filter<IntMap<_>> implements ImplicitInstance {
	public function filter <A>(fa:IntMap<A>, fn:A->Bool):IntMap<A> {
		return [
			for (k in fa.keys()) if (fn(fa.get(k))) k => fa.get(k)
		];
	}
}

class App {
	public static function main () {
		var a = [1,2,3,4];

		trace(ContainerApi.hasElem(a, 2));
		ContainerApi.forEach(a, x -> trace(x));

		trace(ContainerApi.filter(a, x -> x == 1));
		trace(ContainerApi.map(a, x -> "foo" + x));

		trace(ContainerApi.mapWithKey(a, (i:Int,x) -> 'at($i) = $x' ));

		var a:Map<String, Int> = [ "key" => 100 ];

		//ContainerApi.hasElem(a, 2);
		ContainerApi.forEach(a, x -> trace(x));

		trace(ContainerApi.filter(a, x -> x == 1));

		trace(ContainerApi.mapWithKey(a, (i:String, x) -> 'at($i) = $x' ));

		var a:Map<Int, Int> = [ 2 => 100 ];

		ContainerApi.forEach(a, x -> trace(x));

		trace(ContainerApi.filter(a, x -> x == 1));
	}
}