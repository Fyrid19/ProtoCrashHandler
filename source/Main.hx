package;

import flixel.FlxGame;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;

import haxe.ui.Toolkit;

class Main extends Sprite {
    public static function main():Void {
        Lib.current.addChild(new Main());
    }

    public function new():Void {
        super();

        if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(?e:Event):Void {
        if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);

        setupGame();
    }

    private function setupGame():Void {
        addChild(new FlxGame(1280, 720, PlayState, 60, 60, true, false));

        Toolkit.theme = 'dark';
        Toolkit.init();
    }
}