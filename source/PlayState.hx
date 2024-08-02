package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import haxe.ui.Toolkit;
import haxe.ui.styles.Style;
import haxe.ui.containers.Box;
import haxe.ui.components.*;

import openfl.Assets;
import openfl.errors.Error;

class PlayState extends FlxState {
    var textFont:String = 'vcr.ttf';

    public final repoLink:String = 'https://github.com/Fyrid19/Proto-Engine-FNF';

    public static var errorData:Array<String>;

    override function create() {
        super.create();

        Toolkit.theme = 'dark';
        Toolkit.init();

        var bg:FlxSprite = new FlxSprite().loadGraphic(getImage('menuInvert'));
        bg.setGraphicSize(bg.width * 0.8);
        bg.screenCenter();
        add(bg);

        var errorTxt:FlxText = new FlxText(0, 30, FlxG.width, 'Game Crash' + (errorData[0] != null ? '!' : '?'));
        errorTxt.setFormat(getFont(textFont), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(errorTxt);

        var githubTxt:FlxText = new FlxText(0, errorTxt.y + errorTxt.height + 5, FlxG.width, '');
        githubTxt.setFormat(getFont(textFont), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        githubTxt.text = 'Please report this error to the GitHub page! \n$repoLink';
        add(githubTxt);

        var scrollArea:VerticalScroll = new VerticalScroll();
        scrollArea.color = 0xFFFFFF;
        scrollArea.setSize(FlxG.width * 0.9, FlxG.height * 0.6);
        scrollArea.screenCenter(X);
        scrollArea.y += 150;
        add(scrollArea);

        var page = new Box();
        applyStyle(page.customStyle);
        page.setSize(scrollArea.width, scrollArea.height);
        page.includeInLayout = false;
        scrollArea.addComponent(page);

        var textArea = new TextArea();
        if (errorData != null) {
            textArea.text = '';
            if (errorData[0] != '')
                textArea.text = errorData[0] + '\n\n';
            textArea.text += errorData[1];
        }
        textArea.includeInLayout = false;
        page.addComponent(textArea);

        var repoButton:Button = newButton('Open Git Repo', () -> {
            FlxG.openURL(repoLink + '/issues');
            trace('opening repo url');
        });

        var logButton:Button = newButton('Log Crash', () -> {
            trace('log');
        });

        repoButton.x = 5;
        repoButton.y = FlxG.height - 25 - 5;
        logButton.x = repoButton.x;
        logButton.y = repoButton.y - 25 - 2;
        add(repoButton);
        add(logButton);
    }

    inline function newButton(text:String, clickFunction:Void->Void) {
        var button:Button = new Button();
        applyStyle(button.customStyle);
        button.onClick = (_) -> clickFunction();
        button.includeInLayout = false;
        button.text = text;
        button.focus = false;
        return button;
    }

    inline function applyStyle(style:Style) {
        style.backgroundColor = 0x383838;
        style.borderColor = 0xFFFFFF;
        style.borderRadius = 16;
        style.borderSize = 10;
    }

    inline function getImage(key:String) {
        return 'assets/images/$key.png';
    }

    inline function getFont(key:String) {
        return 'assets/fonts/$key';
    }
}