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

import sys.FileSystem;
import sys.io.File;

using StringTools;

class PlayState extends FlxState {
    var textFont:String = 'vcr.ttf';

    public final repoLink:String = 'https://github.com/Fyrid19/Proto-Engine-FNF';

    public static var errMsg:String = null;
    public static var errData:String = null;
    public static var crashDate:String = null;
    var dateFormat:String;

    override function create() {
        super.create();

        Toolkit.theme = 'dark';
        Toolkit.init();

        if (crashDate == null)
            crashDate = Date.now().toString();
        dateFormat = crashDate.replace(" ", "_").replace(":", "'");

        var bg:FlxSprite = new FlxSprite().loadGraphic(getImage('menuInvert'));
        bg.setGraphicSize(bg.width * 0.8);
        bg.screenCenter();
        // bg.color = 0x0066FF;
        add(bg);

        var errorTxt:FlxText = new FlxText(0, 30, FlxG.width, 'Game Crash' + (errMsg != null ? '!' : '?'));
        errorTxt.setFormat(getFont(textFont), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(errorTxt);

        var githubTxt:FlxText = new FlxText(0, errorTxt.y + errorTxt.height + 5, FlxG.width, '');
        githubTxt.setFormat(getFont(textFont), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        githubTxt.text = 'Please report this error to the GitHub page! \n$repoLink';
        add(githubTxt);

        var dateTxt:FlxText = new FlxText(5, 5, FlxG.width);
        dateTxt.setFormat(getFont(textFont), 12, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        dateTxt.text = 'Crashed at $crashDate';
        add(dateTxt);

        var creditTxt:FlxText = new FlxText(5, dateTxt.y + dateTxt.height, FlxG.width);
        creditTxt.setFormat(getFont(textFont), 12, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        creditTxt.text = 'Original code by sqirra-rng';
        add(creditTxt);

        var page = new Box();
        applyStyle(page.customStyle);
        page.setSize(FlxG.width * 0.9, FlxG.height * 0.6);
        page.screenCenter(X);
        page.y += 150;
        add(page);

        var scrollArea:VerticalScroll = new VerticalScroll();
        scrollArea.setSize(page.width, page.height);
        scrollArea.includeInLayout = false;
        page.addComponent(scrollArea);

        var textArea = new TextArea();
        applyStyle(textArea.customStyle);
        textArea.setSize(page.width, page.height);
        textArea.text = (errMsg != null ? '$errMsg\n\n' : '');
        textArea.text += (errData != null ? errData : 'No errors found!');
        textArea.includeInLayout = false;
        scrollArea.addComponent(textArea);

        var repoButton:Button = newButton('Open Git Repo', () -> {
            FlxG.openURL(repoLink + '/issues');
            trace('opening repo url');
        });

        var logButton:Button = newButton('Log Crash', () -> {
            logCrash();
            trace('logging');
        });

        repoButton.x = 5;
        repoButton.y = FlxG.height - 25 - 5;
        logButton.x = repoButton.x;
        logButton.y = repoButton.y - 25 - 2;
        add(repoButton);
        add(logButton);
    }

    function logCrash() {
        var appVer:String = '1.0';
        var fileName:String = 'ProtoCrashLog_' + dateFormat + '.txt';
        final errCompact:String = 'Prototype Engine Crash Handler v' + appVer + '\n'
        + errMsg + '\n\n' 
        + errData + '\n\n' + 'Crash at $crashDate\n' 
        + 'Original code by sqirra-rng';
        if (!FileSystem.exists("./crashlog/"))
            FileSystem.createDirectory("./crashlog/");

        if (!FileSystem.exists("./crashlog/" + fileName))
            File.saveContent("./crashlog/" + fileName, errCompact);
        else
            trace('log exists already');
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