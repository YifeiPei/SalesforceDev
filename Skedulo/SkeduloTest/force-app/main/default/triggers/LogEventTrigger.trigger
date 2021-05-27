trigger LogEventTrigger on LogEvent__e (after insert) {
    List<Apex_Log__c> logs = new List<Apex_Log__c>();
    
    for (LogEvent__e logEvent : trigger.new) {
        Apex_Log__c newLog = new Apex_Log__c();
        newLog.Current_User__c = logEvent.Current_User__c;
        newLog.Message__c = logEvent.Message__c;
        newLog.Handler__c = logEvent.Handler__c;
        newLog.Parameters__c = logEvent.Parameters__c;
        newLog.Type__c = logEvent.Type__c;
        logs.add(newLog);
    }
    
    insert logs;
}