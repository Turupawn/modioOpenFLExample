package;


import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import ModioWrapper;


class Main extends Sprite {
	
	
	private var cacheTime:Int;
	private var speed:Float;
	private var sprite:Sprite;
	
	
	public function new () {
		
		super ();

		//// Begin mod.io wrapper login ////
		
		ModioWrapper.init(1, 7, "e91c01b8882f4affeddd56c96111977b");

		// First let's check if the user is already logged in
		var is_logged_in = ModioWrapper.isLoggedIn();
		if(!is_logged_in)
		{
			//If he's not let's ask him for the email
			trace("Please enter your email:");
			var email = Sys.stdin().readLine();

			ModioWrapper.emailRequest(email, function (resonse_code:Int)
			{
				if (resonse_code == 200)
				{
					trace("Email request successful");
					
					// A 5 digit security code will be sent to his email
					trace("Please enter the 5 digit security code:");
					var security_code = Sys.stdin().readLine();
					ModioWrapper.emailExchange(security_code, function (resonse_code:Int)
					{
						if (resonse_code == 200)
						{
							trace("Code exchanged! You are now logged in.");
							// A token will be stored on the .modio/ directory.
							// Now the user can query his mods, upload new ones and automatic downloads will be enabled on the background.
						}
						else
						{
							trace("Error exchanging code");
						}
					});
				}
				else
				{
					trace("Error sending code");
				}
			});
		}else
		{
			trace("You are already logged in. Do you want to logout? (y/n)");
			var option = Sys.stdin().readLine();
			if(option=="y")
			{
				ModioWrapper.logout();
				trace("You are now logged out");
			}
		}

		//// End mod.io wrapper login ////
		
		sprite = new Sprite ();
		sprite.graphics.beginFill (0x24AFC4);
		sprite.graphics.drawRect (0, 0, 100, 100);
		sprite.y = 50;
		addChild (sprite);
		
		speed = 0.3;
		cacheTime = Lib.getTimer ();
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
	}
	
	
	private function update (deltaTime:Int):Void {
		
		if (sprite.x + sprite.width >= stage.stageWidth || sprite.x < 0) {
			
			speed *= -1;
			
		}
		
		sprite.x += speed * deltaTime;

		//// Call this to process callbacks and events ////

		ModioWrapper.process();
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		var currentTime = Lib.getTimer ();
		update (currentTime - cacheTime);
		cacheTime = currentTime;
		
	}
	
	
}