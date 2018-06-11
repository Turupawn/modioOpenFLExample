class ModioWrapper
{
  #if linux
    public static var init:Int->Int->String->Void = cpp.Lib.load("modioWrapperLinux","modioWrapperInit",3);
    public static var process:Void->Void = cpp.Lib.load("modioWrapperLinux","modioWrapperProcess",0);
    public static var isLoggedIn:Void->Bool = cpp.Lib.load("modioWrapperLinux","modioWrapperIsLoggedIn",0);
    public static var logout:Void->Bool = cpp.Lib.load("modioWrapperLinux","modioWrapperLogout",0);
    public static var emailRequest:String->(Int->Void)->Void = cpp.Lib.load("modioWrapperLinux","modioWrapperEmailRequest",2);
    public static var emailExchange:String->(Int->Void)->Void = cpp.Lib.load("modioWrapperLinux","modioWrapperEmailExchange",2);
  #end
}