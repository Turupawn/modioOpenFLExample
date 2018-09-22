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

class Authentication extends Sprite {
	
	private var user_input = "";
	private var state = "waiting for email";
	var authentication_text:TextField;
	var text_field:TextField;
	var download_listener_text:TextField;
	var download_progress_text:TextField;
	var current_user_text:TextField;

	public function displayAuthenticatedUser()
	{
		ModioWrapper.getAuthenticatedUser(function(response:Dynamic, user:Dynamic)
		{
			if(response.code == 200)
			{
				current_user_text.text = "Hello " + user.username + "!";
			}else
			{
				current_user_text.text = "Error retrieving the authenticated user info.";
			}
		});
	}

	public function displayDownloadProgress()
	{
		var download_queue:Array<Dynamic>;
		download_queue = ModioWrapper.getModDownloadQueue();
		if(download_queue.length > 0)
		{
			var progress = download_queue[0].current_progress / download_queue[0].total_size;
			progress = Math.round( progress * 100 * Math.pow(10, 2) ) / Math.pow(10, 2);
			var download_progress = "Downloading... ";
			if(download_queue[0].current_progress > 0)
				download_progress += progress + "%";
			if(download_queue.length > 1)
				download_progress += " (" + (download_queue.length - 1) + " downloads queued)";
			download_progress_text.text = download_progress;
		}else
		{
			download_progress_text.text = "";
		}
	}
	
	public function new () {
		
		super ();

		// First let's initialize mod.io by providing the environment type, your game id and your API key
		// You can grab your game id and API key from the mod.io web
		ModioWrapper.init(ModioWrapper.MODIO_ENVIRONMENT_TEST, 7, "e91c01b8882f4affeddd56c96111977b");

		// Now let's add a label and text field to retreive input from the user
		authentication_text = new TextField();
		authentication_text.text = "Please enter your email:";
		addChild( authentication_text );
		
		text_field = new TextField();
		text_field.text = "";
		text_field.y = 20;
		text_field.height = 20;
		text_field.width = 200;
		text_field.type = TextFieldType.INPUT;
		text_field.border = true;
		addChild( text_field );

		download_listener_text = new TextField();
		download_listener_text.text = "";
		download_listener_text.y = 100;
		download_listener_text.height = 20;
		download_listener_text.width = 200;
		addChild( download_listener_text );

		download_progress_text = new TextField();
		download_progress_text.text = "";
		download_progress_text.y = 150;
		download_progress_text.height = 20;
		download_progress_text.width = 200;
		addChild( download_progress_text );

		current_user_text = new TextField();
		current_user_text.text = "Loading...";
		current_user_text.x = 350;
		current_user_text.height = 20;
		current_user_text.width = 200;
		addChild( current_user_text );

		if(ModioWrapper.isLoggedIn())
		{
			download_listener_text.text = "Listening to events...";
			displayAuthenticatedUser();
		}else
		{
			current_user_text.text = "You are not logged in";
		}
		
		ModioWrapper.setDownloadListener(function(response_code:Int, mod_id:Int)
		{
			if(response_code == 200 || response_code == 206)
			{
				download_listener_text.text = "Mod installed! Mod id: " + mod_id;
				var installed_mods:Array<Dynamic>;
				installed_mods = ModioWrapper.getInstalledMods();
				for(i in 0...installed_mods.length)
				{
					if(installed_mods[i].mod_id == mod_id)
					{
						download_listener_text.text += " Local path: " + installed_mods[i].path;
					}
				}
			}else
			{
				download_listener_text.text = "Error installing mod.";
			}
		});
		
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
		displayDownloadProgress();

		// Now let's check if the user has entered an input
		if(user_input != "")
		{
			if(state == "waiting for email")
			{
				authentication_text.text = "Wating...";
				var email = user_input;
				user_input = "";

				// To authenticate, the user provides his email. A security code will be sent there
				ModioWrapper.emailRequest(email, function (response:Dynamic)
				{
					if (response.code == 200)
					{
						authentication_text.text = "Please enter the 5 digit code sent to your email:";
						state = "waiting for code";
					}
					else
					{
						authentication_text.text = "Error sending code";
					}
				});
			}
			if(state == "waiting for code")
			{
				authentication_text.text = "Wating...";
				var security_code = user_input;
				user_input = "";
				
				// To complete the authentication, the user enters the security code sent to his email
				ModioWrapper.emailExchange(security_code, function (response:Dynamic)
				{
					if (response.code == 200)
					{
						authentication_text.text = "Code exchanged! You are now logged in.";
						text_field.visible = false;
						download_listener_text.text = "Listening to events...";
						displayAuthenticatedUser();
						// Now an authentication token will be stores on the .modio/ folder
						// This is handled by the SDK on the background so you don't have to worry about it
						// Form now on, the user will be able to browse his mods, upload, subscribe, rate etc...
						// Also, automatic uploads will be enabled so mods will be automatically installed if the user subscribes from the web, plugin, API or SDK
						// To logout call the ModioWrapper.logout() function
					}
					else
					{
						authentication_text.text = "Error exchanging code";
					}
				});
			}
		}
	}
}