package;

import flixel.FlxGame;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;

/**
    Using `sys.io.Process` for when your game crashes, be sure to include every argument needed for the crash handler.

    ---

    `Argument 1:` The actual error that occurred
    
    `Argument 2:` Info from the error's `StackItem`

    `Argument 3:` The date of the error (Mostly optional)

    ---

    @see https://github.com/Fyrid19/ProtoCrashHandler/blob/main/README.md
**/
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
        haxe.ui.Toolkit.theme = 'dark';
        haxe.ui.Toolkit.init();

        PlayState.errMsg = Sys.args()[0];
        PlayState.errData = Sys.args()[1];
        PlayState.crashDate = Sys.args()[2];

        addChild(new FlxGame(960, 540, PlayState, 60, 60, true, false));
    }
}