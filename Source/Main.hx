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
	
	public function new () {
		
		super ();

		// First let's initialize mod.io by providing the environment type, your game id and your API key
		// You can grab your game id and API key from the mod.io web
		ModioWrapper.init(ModioWrapper.MODIO_ENVIRONMENT_TEST, 7, "e91c01b8882f4affeddd56c96111977b");

		// Now let's add a label and text field to retreive input from the user
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

		// Now let's check if the user has entered an input
		if(user_input != "")
		{
			if(state == "waiting for email")
			{
				label.text = "Wating...";
				var email = user_input;
				user_input = "";

				// To authenticate, the user provides his email. A security code will be sent there
				ModioWrapper.emailRequest(email, function (resonse_code:Int)
				{
					if (resonse_code == 200)
					{
						label.text = "Please enter the 5 digit code sent to your email:";
						state = "waiting for code";
					}
					else
					{
						label.text = "Error sending code";
					}
				});
			}
			if(state == "waiting for code")
			{
				label.text = "Wating...";
				var security_code = user_input;
				user_input = "";
				
				// To complete the authentication, the user enters the security code sent to his email
				ModioWrapper.emailExchange(security_code, function (resonse_code:Int)
				{
					if (resonse_code == 200)
					{
						label.text = "Code exchanged! You are now logged in.";
						text_field.visible = false;
						// Now an authentication token will be stores on the .modio/ folder
						// This is handled by the SDK on the background so you don't have to worry about it
						// Form now on, the user will be able to browse his mods, upload, subscribe, rate etc...
						// Also, automatic uploads will be enabled so mods will be automatically installed if the user subscribes from the web, plugin, API or SDK
						// To logout call the ModioWrapper.logout() function
					}
					else
					{
						label.text = "Error exchanging code";
					}
				});
			}
		}
	}
}