public class Exceptions {
    //
    // Exception class indicating a generic error has occurred in the application
    //
    public class ApplicationException extends Exception {

    }

    //
    // Exception class indicating an error has occurred during invocation of a trigger
    //
    public class TriggerHandlerException extends Exception {
       
    }

    //
    // Exception class indicating unauthorized request
    //
    public class UnauthorizedException extends Exception {
 
    }

    //
    // Exception class indicating network unavailable
    // 
    public class NetworkException extends Exception {

    }
}