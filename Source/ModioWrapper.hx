class ModioWrapper
{
  public static var MODIO_ENVIRONMENT_LIVE = 0;
  public static var MODIO_ENVIRONMENT_TEST = 1;
  #if (linux)
    public static var init:Int->Int->String->Void = cpp.Lib.load("modioWrapperLinux_x64","modioWrapperInit",3);
    public static var process:Void->Void = cpp.Lib.load("modioWrapperLinux_x64","modioWrapperProcess",0);
    public static var isLoggedIn:Void->Bool = cpp.Lib.load("modioWrapperLinux_x64","modioWrapperIsLoggedIn",0);
    public static var logout:Void->Bool = cpp.Lib.load("modioWrapperLinux_x64","modioWrapperLogout",0);
    public static var emailRequest:String->(Int->Void)->Void = cpp.Lib.load("modioWrapperLinux_x64","modioWrapperEmailRequest",2);
    public static var emailExchange:String->(Int->Void)->Void = cpp.Lib.load("modioWrapperLinux_x64","modioWrapperEmailExchange",2);
  #end
  #if (windows)
    public static var init:Int->Int->String->Void = cpp.Lib.load("modioWrapperWindows_x86","modioWrapperInit",3);
    public static var process:Void->Void = cpp.Lib.load("modioWrapperWindows_x86","modioWrapperProcess",0);
    public static var isLoggedIn:Void->Bool = cpp.Lib.load("modioWrapperWindows_x86","modioWrapperIsLoggedIn",0);
    public static var logout:Void->Bool = cpp.Lib.load("modioWrapperWindows_x86","modioWrapperLogout",0);
    public static var emailRequest:String->(Int->Void)->Void = cpp.Lib.load("modioWrapperWindows_x86","modioWrapperEmailRequest",2);
    public static var emailExchange:String->(Int->Void)->Void = cpp.Lib.load("modioWrapperWindows_x86","modioWrapperEmailExchange",2);
  #end
}