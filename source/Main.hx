package;

import flixel.FlxGame;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;

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
        PlayState.errorData = Sys.args();
        addChild(new FlxGame(960, 540, PlayState, 60, 60, true, false));
    }
}