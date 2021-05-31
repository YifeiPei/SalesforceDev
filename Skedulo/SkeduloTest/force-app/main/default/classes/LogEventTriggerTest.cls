@isTest
public with sharing class LogEventTriggerTest {
    
    @isTest
    static void testTrigger(){
        Test.startTest();
        LogEvent__e logEvent = new LogEvent__e ();
        logEvent.Current_User__c = 'Test';
        logEvent.Message__c = 'Test';
        logEvent.Handler__c = 'Test';
        logEvent.Parameters__c = 'Test';
        logEvent.Type__c = 'Error';
        EventBus.publish(logEvent);
        Test.stopTest();
    }
}
