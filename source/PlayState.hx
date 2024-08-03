package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import haxe.ui.Toolkit;
import haxe.ui.styles.Style;
import haxe.ui.containers.windows.*;
import haxe.ui.containers.*;
import haxe.ui.components.*;

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

    override function create() {
        super.create();

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

        var creditTxt2:FlxText = new FlxText(5, creditTxt.y + creditTxt.height, FlxG.width);
        creditTxt2.setFormat(getFont(textFont), 12, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        creditTxt2.text = 'Crash handler written by Fyrid19';
        add(creditTxt2);

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

        var textLabel = new Label();
        textLabel.customStyle.left = 10;
        textLabel.customStyle.fontSize = 10;
        textLabel.text = (errMsg != null ? '$errMsg\n\n' : '');
        textLabel.text += (errData != null ? errData : 'No info on the error has been found!');
        textLabel.includeInLayout = false;
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
        sideButtons.y = FlxG.height - 60;
        add(sideButtons);

        sideButtons.addComponent(logButton);
        sideButtons.addComponent(repoButton);
    }

    function logCrash() {
        var appVer:String = '1.0';
        var crashLocation:String = "./crash/crashlog/";
        var fileName:String = 'ProtoCrashLog_' + dateFormat + '.txt';
        var fullFilePath:String = FileSystem.fullPath(crashLocation + fileName);
        final errCompact:String = 'Prototype Engine Crash Handler v' + appVer + '\n'
        + errMsg + '\n\n' 
        + errData + '\n\n' + 'Crash at $crashDate\n' 
        + 'Original code by sqirra-rng';
        if (!FileSystem.exists(crashLocation))
            FileSystem.createDirectory(crashLocation);

        if (!FileSystem.exists(crashLocation + fileName)) {
            File.saveContent(crashLocation + fileName, errCompact);
            showPopup('Crash Log', 'Successfully logged crash to "' + fullFilePath + '"');
        } else {
            showPopup('Crash Log', 'Crash log already exists!');
        }
    }

    function showPopup(title:String, text:String, ?callback:Void->Void) {
        var popup:Window = newWindow(false, false, false, title);
        var label:Label = new Label();
        label.text = text;
        popup.addComponent(label);
        popup.x = FlxG.width/2 - popup.width/2;
        popup.y = FlxG.height/2 - popup.height/2;
        popup.draggable = false;
        add(popup);
    }

    inline function newWindow(minimizable:Bool, collapsable:Bool, maximizable:Bool, title:String) {
        var window:Window = new Window();
        window.minimizable = minimizable;
        window.collapsable = collapsable;
        window.maximizable = maximizable;
        window.title = title;
        window.windowManager = new WindowManager();
        return window;
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
        style.fontSize = 10;
    }

    inline function getImage(key:String) {
        return 'assets/images/$key.png';
    }

    inline function getFont(key:String) {
        return 'assets/fonts/$key';
    }
}