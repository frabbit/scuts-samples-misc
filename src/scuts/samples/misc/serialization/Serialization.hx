package scuts.samples.misc.serialization;

import scuts.Prelude;
import scuts.PreludeApi as P;


abstract Age(Int) {
	public function new (i:Int) this = i;
	public function unwrap () return this;
}

@:structInit class Person {
	public var name:String;
	public var age:Age;
}

enum JsonData {
	JObject(fields:Map<String, JsonData>);
	JString(s:String);
	JInt(i:Int);
	//...
}

class ShowJsonData implements Show<JsonData> implements ImplicitInstance {
	public function show (t:JsonData) {
		return switch t {
			case JObject(fields): "{ " + [for (k in fields.keys()) '$k: ${P.show(fields[k])}'].join(", ")  + " }";
			case JString(s): P.show(s);
			case JInt(i): P.show(i);
		}
	}
}

interface ToJson<T> extends ApiDef {
	function toJson(t:T):JsonData;
}

class JsonApi implements ApiOf<ToJson<_>> {}


class ToJsonPerson implements ToJson<Person> implements ImplicitInstance {
	public function toJson (p:Person):JsonData {
		return JObject([ "age" => JsonApi.toJson(p.age), "name" => JString(p.name)]);
	}
}

class ToJsonAge implements ToJson<Age> implements ImplicitInstance {
	public function toJson (p:Age):JsonData {
		return return JInt(p.unwrap());
	}
}



class App {
	public static function main () {
		var p : Person = { name : "Peter", age : new Age(35) };

		trace(P.show(JsonApi.toJson(p)));
	}
}