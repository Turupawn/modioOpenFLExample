package;


import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import ModioWrapper;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class Main extends Sprite {
	

	private var user_input = "";
	private var state = "waiting for email";
	var text_field:TextField;
	var label:TextField;

	public function emailRequest(email:String)
	{
		ModioWrapper.emailRequest(email, function (resonse_code:Int)
		{
			if (resonse_code == 200)
			{
				label.text = "Please enter the 5 digit code sent to your email:";
				// A 5 digit security code will be sent to his email
				state = "waiting for code";
			}
			else
			{
				label.text = "Error sending code";
			}
		});
	}

	public function emailExchange(security_code:String)
	{
		ModioWrapper.emailExchange(security_code, function (resonse_code:Int)
		{
			if (resonse_code == 200)
			{
				label.text = "Code exchanged! You are now logged in.";
				text_field.visible = false;
				// A token will be stored on the .modio/ directory.
				// Now the user can query his mods, upload new ones and automatic downloads will be enabled on the background.
			}
			else
			{
				label.text = "Error exchanging code";
			}
		});
	}
	
	
	public function new () {
		
		super ();

		//// Begin mod.io wrapper login ////
		ModioWrapper.init(1, 7, "e91c01b8882f4affeddd56c96111977b");

		label = new TextField();
		label.text = "Please enter your email:";
		addChild( label );
		
		text_field = new TextField();
        text_field.text = "";
		text_field.y = 40;
		text_field.height = 20;
		text_field.width = 200;
        text_field.type = TextFieldType.INPUT;
        text_field.border = true;
        addChild( text_field );
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);

		addEventListener(KeyboardEvent.KEY_DOWN, function(evt:KeyboardEvent)
		{
			if( evt.charCode == Keyboard.ENTER)
			{
				user_input = text_field.text;
				text_field.text = "";
			}
		});
	}
	
	private function this_onEnterFrame (event:Event):Void {
		
		ModioWrapper.process();

		if(state == "waiting for email" && user_input != "")
		{
			label.text = "Wating...";
			var email = user_input;
			user_input = "";
			emailRequest(email);
		}

		if(state == "waiting for code" && user_input != "")
		{
			label.text = "Wating...";
			var security_code = user_input;
			user_input = "";
			emailExchange(security_code);
		}
	}
	
	
}