package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

import haxe.ui.Toolkit;
import haxe.ui.styles.Style;
import haxe.ui.containers.*;
import haxe.ui.components.*;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

using StringTools;

/**
 * The inner-workings of the crash handler.
 */
class PlayState extends FlxState {
    /**
     * Text font used for the program.
     */
    var textFont:String = 'vcr.ttf';

    /**
     * The link to your git repositiory.
     */
    public final repoLink:String = 'https://github.com/Fyrid19/Proto-Engine-FNF';

    /**
     * The actual error that occurred.
     */
    public static var errMsg:String = null;

    /**
     * Info on the error, usually consisting of where the error came from.
     */
    public static var errData:String = null;

    /**
     * Exact date of the crash, or if no date can be found defaults to the time you opened the program.
     */
    public static var crashDate:String = null;

    /**
     * "crashDate" but formatted for files.
     */
    var dateFormat:String;

    var logTextGroup:VBox;

    override function create() {
        super.create();

        if (crashDate == null)
            crashDate = Date.now().toString();
        dateFormat = crashDate.replace(" ", "_").replace(":", "-");

        var bg:FlxSprite = new FlxSprite().loadGraphic(getImage('menuInvert'));
        bg.screenCenter();
        // bg.color = 0x0066FF;
        add(bg);

        var errorTxt:FlxText = new FlxText(0, 30, FlxG.width, 'Game Crash' + (errMsg != null ? '!' : '?'));
        errorTxt.setFormat(getFont(textFont), 72, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(errorTxt);

        var githubTxt:FlxText = new FlxText(0, errorTxt.y + errorTxt.height + 5, FlxG.width, '');
        githubTxt.setFormat(getFont(textFont), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        githubTxt.text = 'Please report this error to the GitHub page! \n$repoLink';
        add(githubTxt);

        var dateTxt:FlxText = new FlxText(5, 5, FlxG.width);
        dateTxt.setFormat(getFont(textFont), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        dateTxt.text = 'Crashed at $crashDate';
        add(dateTxt);

        var creditTxt:FlxText = new FlxText(5, dateTxt.y + dateTxt.height, FlxG.width);
        creditTxt.setFormat(getFont(textFont), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        creditTxt.text = 'Original code by sqirra-rng';
        add(creditTxt);

        var creditTxt2:FlxText = new FlxText(5, creditTxt.y + creditTxt.height, FlxG.width);
        creditTxt2.setFormat(getFont(textFont), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        creditTxt2.text = 'Crash handler written by Fyrid19';
        add(creditTxt2);

        var page = new Box();
        applyStyle(page.customStyle);
        page.setSize(FlxG.width * 0.9, FlxG.height * 0.6);
        page.screenCenter(X);
        page.y += githubTxt.y + githubTxt.height + 25;
        add(page);

        var scrollArea:ScrollView = new ScrollView();
        scrollArea.setSize(page.width, page.height);
        scrollArea.scrollMode = 'native';
        page.addComponent(scrollArea);

        var textLabel = new Label();
        textLabel.customStyle.fontSize = 16;
        textLabel.text = (errMsg != null ? '$errMsg\n\n' : '');
        textLabel.text += (errData != null ? errData : 'No info on the error has been found!');
        scrollArea.addComponent(textLabel);

        var repoButton:Button = newButton('Open Git Repo', () -> {
            FlxG.openURL(repoLink + '/issues');
            trace('opening repo url');
        });

        var logButton:Button = newButton('Log Crash', () -> {
            logCrash();
            trace('logging');
        });

        var sideButtons:VBox = new VBox();
        sideButtons.x = 5;
        sideButtons.y = FlxG.height - 76;
        add(sideButtons);

        sideButtons.addComponent(logButton);
        sideButtons.addComponent(repoButton);

        logTextGroup = new VBox();
        logTextGroup.x = FlxG.width * 0.2;
        add(logTextGroup);
    }

    function logCrash() {
        var appVer:String = '1.0';
        var crashLocation:String = "./crash/crashlog/";
        var fileName:String = 'ProtoCrashLog_' + dateFormat + '.txt';
        var normalFilePath:String = Path.normalize(crashLocation + fileName);
        final errCompact:String = 'Prototype Engine Crash Handler v' + appVer + '\n'
        + errMsg + '\n\n' 
        + errData + '\n\n' + 'Crash at $crashDate\n' 
        + 'Original code by sqirra-rng';
        if (!FileSystem.exists("./crash/")) {
            crashLocation = "./crashlog/";
            normalFilePath = Path.normalize(crashLocation + fileName);
        }

        if (!FileSystem.exists(crashLocation))
            FileSystem.createDirectory(crashLocation);

        if (!FileSystem.exists(crashLocation + fileName)) {
            File.saveContent(crashLocation + fileName, errCompact);
            traceLog('Saved crash log to "' + normalFilePath + '"', 0x00FF00);
        } else {
            traceLog('Crash log already exists!', 0xFF0000);
        }
    }

    function traceLog(text:String, ?color:FlxColor = FlxColor.WHITE) {
        var logText:Label = new Label();
        logText.width = FlxG.width * 0.8;
        logText.text = text;
        logText.customStyle.color = color;
        logText.customStyle.fontSize = 24;
        logText.textAlign = 'right';
        logText.wordWrap = true;
        logTextGroup.addComponent(logText);
        new FlxTimer().start(4, function(tmr:FlxTimer) {
            FlxTween.tween(logText, {alpha: 0}, 1, {onComplete: function(t) logTextGroup.removeComponent(logText)});
        });
    }

    inline function newButton(text:String, clickFunction:Void->Void) {
        var button:Button = new Button();
        applyStyle(button.customStyle);
        button.onClick = (_) -> clickFunction();
        button.text = text;
        button.focus = false;
        return button;
    }

    inline function applyStyle(style:Style) {
        style.backgroundColor = 0x383838;
        style.borderColor = 0xFFFFFF;
        style.borderRadius = 16;
        style.borderSize = 10;
        style.fontSize = 16;
    }

    inline function getImage(key:String) {
        return returnPath('$key.png', 'images');
    }

    inline function getFont(key:String) {
        return returnPath(key, 'fonts');
    }

    inline function returnPath(key:String, folder:String) {
        var path:String = 'assets/$folder/$key';
        if (FileSystem.exists('crash'))
            path = 'crash/assets/$folder/$key';
        return FileSystem.exists(path) ? path : null;
    }
}