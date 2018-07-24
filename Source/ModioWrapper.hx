class ModCreator
{
    public var logo_path:String;
    public var name:String;
    public var summary:String;
    public function new()
    {
        logo_path = "";
        name = "";
        summary = "";
    }
}

class ModEditor
{
    public var logo_path:String;
    public var name:String;
    public var summary:String;
    public function new()
    {
        logo_path = "";
        name = "";
        summary = "";
    }
}

class ModfileCreator
{
    public var logo_path:String;
    public var name:String;
    public var summary:String;
    public function new()
    {
        logo_path = "";
        name = "";
        summary = "";
    }
}

class ModioWrapper
{
    private static function load(name:String, args:Int):Dynamic {
        try{return cpp.Lib.load(ndll_name, name, args);}catch(e:Dynamic){return null;}
    }

    public static var MODIO_ENVIRONMENT_LIVE = 0;
    public static var MODIO_ENVIRONMENT_TEST = 1;

    public static var MODIO_SORT_BY_ID            = 0;
    public static var MODIO_SORT_BY_RATING        = 1;
    public static var MODIO_SORT_BY_DATE_LIVE     = 2;
    public static var MODIO_SORT_BY_DATE_UPDATED  = 3;

    #if (linux)
    static var ndll_name:String = "modioWrapperLinux_x64";
    #end
    #if (windows)
    static var ndll_name:String = "modioWrapperWindows_x86";
    #end
    #if (macos)
    static var ndll_name:String = "modioWrapperMacOS";
    #end

    public static var init:Int->Int->String->Void = load("modioWrapperInit",3);
    public static var process:Void->Void = load("modioWrapperProcess",0);

    public static var emailRequest:String->(Int->Void)->Void = load("modioWrapperEmailRequest",2);
    public static var emailExchange:String->(Int->Void)->Void = load("modioWrapperEmailExchange",2);
    public static var isLoggedIn:Void->Bool = load("modioWrapperIsLoggedIn",0);
    public static var logout:Void->Bool = load("modioWrapperLogout",0);
    public static var getMods:Int->Int->Int->(Array<Dynamic>->Int->Void)->Int = load("modioWrapperGetMods",4);
    public static var subscribeToMod:Int->(Int->Void)->Void = load("modioWrapperSubscribeToMod",2);
    public static var unsubscribeFromMod:Int->(Int->Void)->Void = load("modioWrapperUnsubscribeFromMod",2);
    public static var installMod:Int->Void = load("modioWrapperInstallMod",1);
    public static var uninstallMod:Int->Void = load("modioWrapperUninstallMod",1);
    public static var pauseDownloads:Void->Void = load("modioWrapperPauseDownloads",0);
    public static var resumeDownloads:Void->Void = load("modioWrapperResumeDownloads",0);
    public static var prioritizeDownload:Int->Void = load("modioWrapperPrioritizeDownload",1);
    public static var setDownloadListener:(Int->Int->Void)->Void = load("modioWrapperSetDownloadListener",1);
    public static var getModDownloadQueue:Void->Array<Dynamic> = load("modioWrapperGetModDownloadQueue",0);
    public static var setUploadListener:(Int->Int->Void)->Void = load("modioWrapperSetUploadListener",1);
    public static var getModfileUploadQueue:Void->Array<Dynamic> = load("modioWrapperGetModfileUploadQueue",0);
    public static var getInstalledMods:Void->Array<Dynamic> = load("modioWrapperGetInstalledMods",0);
    public static var getModState:Int->Int = load("modioWrapperGetModState",1);
    public static var addMod:ModCreator->(Int->Void)->Int = load("modioWrapperAddMod", 2);
    public static var editMod:Int->ModEditor->(Int->Void)->Int = load("modioWrapperEditMod", 3);
    public static var addModfile:Int->ModfileCreator->(Int->Void)->Int = load("modioWrapperAddModfile", 2);
    public static var getAuthenticatedUser:(Int->Dynamic->Void)->Int = load("modioWrapperGetAuthenticatedUser", 1);
}