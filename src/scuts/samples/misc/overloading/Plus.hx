package scuts.samples.misc.overloading;

import scuts.Prelude;
import scuts.PreludeApi as P;

using scuts.samples.misc.overloading.Plus.MulApi;

@:structInit class Vec2 {
	public var x:Float;
	public var y:Float;
}

@:structInit class Vec3 {
	public var x:Float;
	public var y:Float;
	public var z:Float;
}

@:structInit class Mat2 {
	public var _11:Float;
	public var _12:Float;
	public var _21:Float;
	public var _22:Float;
}

@:funDeps((A,B) -> C) interface Mul<A,B,C> extends ApiDef {
	public function mul (a:A, b:B):C;
}

class MulIntInt implements Mul<Int,Int,Int> implements ImplicitInstance {
	function mul (a:Int, b:Int):Int return a * b;
}

class MulFloatVec2 implements Mul<Float,Vec2,Vec2> implements ImplicitInstance {
	function mul (a:Float, b:Vec2):Vec2 return { x : b.x * a, y : b.y * a };
}

class MulFloatMat2 implements Mul<Float,Mat2,Mat2> implements ImplicitInstance {
	function mul (a:Float, b:Mat2):Mat2 return {
		_11 : b._11 * a,
		_12 : b._12 * a,
		_21 : b._21 * a,
		_22 : b._22 * a,
	}
}

class MulMat2Float implements Mul<Mat2, Float ,Mat2> implements ImplicitInstance {
	function mul (b:Mat2, a:Float):Mat2 return {
		_11 : b._11 * a,
		_12 : b._12 * a,
		_21 : b._21 * a,
		_22 : b._22 * a,
	}
}

class MulFloatVec3 implements Mul<Float,Vec3,Vec3> implements ImplicitInstance {
	function mul (a:Float, b:Vec3):Vec3 return { x : b.x * a, y : b.y * a, z: b.z * a };
}

class MulVec2Float implements Mul<Vec2,Float,Vec2> implements ImplicitInstance {
	function mul (a:Vec2, b:Float):Vec2 return { x : a.x * b, y : a.y * b };
}


class MulVec3Float implements Mul<Vec3,Float,Vec3> implements ImplicitInstance {
	function mul (a:Vec3, b:Float):Vec3 return { x : a.x * b, y : a.y * b, z: a.z * b };
}

class ShowVec3 implements Show<Vec3> implements ImplicitInstance {
	function show(v:Vec3):String return '{ x: ${v.x}, y: ${v.y}, z: ${v.z} }';
}

class ShowVec2 implements Show<Vec2> implements ImplicitInstance {
	function show(v:Vec2):String return '{ x: ${v.x}, y: ${v.y} }';
}

class ShowMat2 implements Show<Mat2> implements ImplicitInstance {
	function show(v:Mat2):String return '{ _11: ${v._11}, _12: ${v._12}, _21: ${v._21}, _22: ${v._22} }';
}




class MulApi implements ApiOf<Mul<_,_,_>> {}

class App {

	public static function main () {
		var v2:Vec2 = { x : 1.0, y: 2.0 };
		var v3:Vec3 = { x : 2.0, y: 2.0, z: 3.0 };
		var m2:Mat2 = { _11: 1.0, _12: 2.0, _21: 3.0, _22: 4.0 };
		var i = 2.1;

		trace(P.show(i.mul(v2)));
		trace(P.show(i.mul(v3)));

		trace(P.show(v2.mul(i)));
		trace(P.show(v2.mul(i)));

		trace(P.show(i.mul(m2)));

		trace(P.show(m2.mul(i)));



	}

}