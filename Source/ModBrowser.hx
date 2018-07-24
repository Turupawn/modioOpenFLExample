package;

import ModioWrapper;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;
import openfl.display.BitmapData;
import sys.io.FileOutput;

class ModDisplay extends Sprite {
  public var id = 0;
  public var mod_name = new TextField();
  public var mod_description = new TextField();
  public var button = new Sprite();

  public function new (mod_name_text_format:TextFormat, mod_description_text_format:TextFormat) {
    super();
    mod_name.setTextFormat(mod_name_text_format);
    mod_description.setTextFormat(mod_description_text_format);
    mod_name.x = 330;
    mod_description.x = 330;
    mod_description.y = 30;
    button.addChild(new Bitmap (Assets.getBitmapData ("assets/subscribe.png")));
    button.x = 580;
    button.addEventListener(MouseEvent.CLICK, function onButtonClick(e:MouseEvent) {
      //TODO subscribe on click
    });

    addChild(mod_name);
    addChild(mod_description);
    addChild(button);
  }

  public function loadImage(url:String) {
    var httpInstance = new haxe.Http(url);
    httpInstance.onData = function(data) {
    var file_output:FileOutput = sys.io.File.write("assets/" + this.id + ".jpg", true);
    file_output.writeString(data);
    trace(data.length + " bytes downloaded");
    file_output.close();
    BitmapData.loadFromFile ("assets/" + this.id + ".jpg").onComplete (function (bitmapData) {
    trace ("loaded");
    addChild(new Bitmap (bitmapData));
    }).onError (function (e) {
    trace ("error");
    }).onProgress (function (loaded, total) {
    trace ("loaded " + loaded + "/" + total);
    });
    }
    httpInstance.request();
  }

  public function display(id:Int, name:String, description:String, image_url:String) {
    this.id = id;
    this.mod_name.text = name;
    if(description.length < 50)
    this.mod_description.text = description;
    else
    this.mod_description.text = description.substr(0,50) + "...";        
    this.loadImage(image_url);
  }
}

class ModBrowserMenu extends Sprite {

  var mods_per_page = 0;
  var current_page = 0;
  var mod_displays:haxe.ds.Vector<ModDisplay>;
  var left_button:Sprite = new Sprite();
  var right_button:Sprite = new Sprite();
  var mod_name_text_format:TextFormat;
  var mod_description_text_format:TextFormat;

  public function getMods(page:Int){
    ModioWrapper.getMods(ModioWrapper.MODIO_SORT_BY_RATING, mods_per_page, page * mods_per_page, function(mods:Array<Dynamic>, response_code:Int) {
      if(response_code == 200)
      {
        for (i in 0...mods_per_page)
        {
          mod_displays[i].display(mods[i].id, mods[i].name, mods[i].description, mods[i].logo.thumb_320x180);
        }
      }
    });
  }

  public function new (mods_per_page:Int, mod_name_text_format:TextFormat, mod_description_text_format:TextFormat) {
    super ();

    this.mods_per_page = mods_per_page;
    this.mod_name_text_format = mod_name_text_format;
    this.mod_description_text_format = mod_description_text_format;

    mod_displays = new haxe.ds.Vector(mods_per_page);

    left_button.addChild(new Bitmap (Assets.getBitmapData ("assets/left.png")));
    right_button.addChild(new Bitmap (Assets.getBitmapData ("assets/right.png")));

    left_button.addEventListener(MouseEvent.CLICK, function onButtonClick(e:MouseEvent) {
      current_page -= 1;
      getMods(current_page);
    });

    right_button.addEventListener(MouseEvent.CLICK, function onButtonClick(e:MouseEvent) {
      current_page += 1;
      getMods(current_page);
    });

    left_button.x = 700;
    right_button.x = 750;
    left_button.y = 550;
    right_button.y = 550;

    addChild(left_button);
    addChild(right_button);

    for (i in 0...mods_per_page) {
      var mod_display = new ModDisplay(mod_name_text_format, mod_description_text_format);
      mod_display.y = i * 185;
      mod_displays[i] = mod_display;
      addChild(mod_display);
    }

    getMods(current_page);    
  }
}

class ModBrowser extends ModBrowserMenu {
  public function new () {
    ModioWrapper.init(ModioWrapper.MODIO_ENVIRONMENT_TEST, 7, "e91c01b8882f4affeddd56c96111977b");

    var mod_name_text_format:TextFormat = new TextFormat();
    mod_name_text_format.size = 15;
    var mod_description_text_format:TextFormat = new TextFormat();
    super (3, mod_name_text_format, mod_description_text_format);

    addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
  }

  private function this_onEnterFrame (event:Event):Void {
    ModioWrapper.process();
  }
}