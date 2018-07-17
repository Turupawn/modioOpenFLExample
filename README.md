
# OpenFL integration

Follow these steps to integrate the [mod.io SDK Haxe wrapper](https://github.com/Turupawn/modioHaxe) into your OpenFL project.

## Step 1: The setup

* Download the wrapper from the [modioHaxe releases page](https://github.com/Turupawn/modioHaxe/releases) page and extract it.
* Place the `ModioWrapper.hx` on your `Sources/` directory.
* Place the `.ndll` files on your project's directory
* Add the following in your `project.xml`

**Note:** You will need to install the [Visual C++ Redistributable for Visual Studio](https://www.microsoft.com/en-US/download/details.aspx?id=48145) in order to use the the `modio.dll` library on your windows project.

```
<ndll name="modioWrapperLinux_x64" if="linux"/>
<ndll name="modioWrapperWindows_x86" if="windows"/>
```

## Step 2: The code

* Import the ModioWrapper class by adding `import ModioWrapper;` in your game's source code.
* Add the mod.io functionality, so far the following functions are available:

### General purpose functions

#### init

Initializes the mod.io wrapper. You will need the game id and api key, you can grab them from the mod.io web.

```
ModioWrapper.init(ModioWrapper.MODIO_ENVIRONMENT_TEST, YOUR_GAME_ID, "YOUR API KEY");
```

#### process

Process the callbacks and events. Call this frequently, preferably on your update function.

```
ModioWrapper.process();
```

### Authentication functions

To authenticate a user, you will have to ask for their email and then a 5-digit security code sent to their email.
To do so, first call emailRequest to send the email and then emailExchange to exchange the security code for an
access token that will be handled internally by the SDK so you won't need to deal with it.

#### emailRequest

Sends an email to the user with the security code needed to login.

```
ModioWrapper.emailRequest(email, function (resonse_code:Int)
{
  if (resonse_code == 200)
  {
    // The user is now successfully logged in
  }
  else
  {
    // Error while sending the authentication email
  }
});
```

#### emailExchange

Exchanges the security code to complete the authentication.

```
ModioWrapper.emailExchange(security_code, function (resonse_code:Int)
{
  if (resonse_code == 200)
  {
    // The code was exchanged successfully
  }
  else
  {
    // Error exchanging the security code
  }
});
```

#### isLoggedIn

Returns true if the user is logged in.

```
ModioWrapper.isLoggedIn();
```

#### logout

Logs out the user.

```
ModioWrapper.logout();
```

For a complete list of functions wrapped so far, check out the [modioHaxe wiki](https://github.com/Turupawn/modioHaxe/wiki).

## Step 3: Building and running

* Complie and run using `openfl build windows` or `openfl build linux`. Mac OS is not supported yet.
* Add the corresponding library (`libmodio.so` or `modio.dll`) from the provided `Lib/` folder into your exported `bin/` directory, next to your binary executable.
* Now, you should be able to execute the game.
