package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import haxe.ui.components.*;

class PlayState extends FlxState {
    var bg:FlxSprite;
    var errorText:FlxText;
    var scrollArea:VerticalScroll;

    var textFont:String = 'vcr.ttf';

    override function create() {
        super.create();

        errorText = new FlxText(0, 0, FlxG.width, 'Game Crash!');
        errorText.setFormat(getFont(textFont), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(errorText);

        scrollArea = new VerticalScroll();
        scrollArea.setSize(FlxG.width * 0.8, FlxG.height * 0.7);
        scrollArea.screenCenter(X);
        scrollArea.y += 100;
        add(scrollArea);
    }

    inline function getFont(key:String) {
        return 'assets/fonts/$key';
    }
}