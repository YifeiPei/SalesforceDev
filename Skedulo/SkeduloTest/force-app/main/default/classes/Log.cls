public class Log {
    public static void info(String className, String functionName, String message) {
        create(LoggingLevel.INFO, className, functionName, message, null);
    }

    public static void error(String className, String functionName, String message) {
        create(LoggingLevel.ERROR, className, functionName, message, null);
    }

    public static void error(String className, String functionName, String message, Exception ex) {
        error(className, functionName, message, ex, null);
    }

    public static void error(String className, String functionName, String message, Exception ex, String para) {
        String logMessage = String.format('{0}\n Exception Message: {1} \n Type: {2} \n StackTrace: {3}', new String[] { message, ex.getMessage(), ex.getTypeName(), ex.getStackTraceString() });
        create(LoggingLevel.ERROR, className, functionName, logMessage, para);
    }

    private static void create(LoggingLevel level, String className, String functionName, String message, String para) {
        String handler = String.format('{0}.{1}', new List<String>{className, functionName});
        String logMessage = String.format('[{0}][{1}] {2}', new List<String>{ Datetime.now().format('dd/MM/yyyy hh:mm:ss:SSS'), handler, message });

        System.debug(level, logMessage);
        
        if (level == LoggingLevel.ERROR) {
            LogEvent__e evt = new LogEvent__e();
            evt.Current_User__c = UserInfo.getUserName();
            evt.Handler__c = handler;
            evt.Message__c = message;
            evt.Parameters__c = para;
            evt.Type__c = String.valueOf(level);
            logEvent(evt);
        }
    }

    private static void logEvent(LogEvent__e evt) {
        EventBus.publish(evt);
    }
}