package scuts.samples.misc.getImages;

import scuts.Prelude;
import scuts.PreludeApi as P;

@:structInit class Image {
	public var url:String;
}

@:structInit class Rock {
	public var bg:Image;
	public var sprite:Image;
}

@:structInit class Player {
	public var sprite:Image;
	public var mask:Image;
}

@:structInit class Enemy {
	public var sprite:Image;
}

interface GetImages<T> extends ApiDef {
	public function images (t:T):Array<Image>;
}

class Api implements ApiOf<GetImages<_>> {}

class GetImagesRock implements GetImages<Rock> implements ImplicitInstance {
	public function images (t:Rock):Array<Image> {
		return [t.bg, t.sprite];
	}
}

class GetImagesEnemy implements GetImages<Enemy> implements ImplicitInstance {
	public function images (t:Enemy):Array<Image> {
		return [t.sprite];
	}
}

class GetImagesPlayer implements GetImages<Player> implements ImplicitInstance {
	public function images (t:Player):Array<Image> {
		return [t.sprite, t.mask];
	}
}

class GetImagesArray<T> implements GetImages<Array<T>> implements ImplicitInstance {
	final getImagesT:GetImages<T>;

	public function images (t:Array<T>):Array<Image> {
		return [for (e in t) for (img in getImagesT.images(e)) img];
	}
}

class ShowImage implements Show<Image> implements ImplicitInstance {
	function show (i:Image) return "Image(" + i.url + ")";
}

class App {
	public static function main () {
		var img1:Image = { url : "1.jpg" };
		var img2:Image = { url : "2.jpg" };
		var img3:Image = { url : "3.jpg" };
		var img4:Image = { url : "4.jpg" };

		var r : Rock = { bg : img1, sprite : img2 };
		var e1 : Enemy = { sprite : img3 };
		var e2 : Enemy = { sprite : img4 };

		var enemies = [e1, e2];


		trace(P.show(Api.images(r)));
		trace(P.show(Api.images(e1)));
		trace(P.show(Api.images(e2)));
		trace(P.show(Api.images(enemies)));




	}
}