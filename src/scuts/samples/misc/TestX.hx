package scuts.samples.misc;

interface Plus<T> {
    public function plus (t:T, s:T):T;
}
class PlusFloat implements Plus<Float>  {
    function new () {}
    public static final instance = new PlusFloat();
    public inline function plus (t1:Float, t2:Float):Float return t1 + t2;
}

class TestX {
    public static function main () {
        var acc = 0.0;
        acc += PlusFloat.instance.plus(1,2);
        for (i in 0...200) {
            acc = acc + plusConstraint(2.2, 2.7, PlusFloat.instance);
        }
        var q = acc;
        trace(q);
    }
    inline static function plusConstraint <T,S:Plus<T>>(a:T, b:T, A:S) {
        return A.plus(a, b);
    }
}