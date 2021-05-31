@isTest
public with sharing class ContactTriggerTest {

    @TestSetup
    static void makeData(){
        TestDataSetup.generateAccountsContacts();
    }

    @isTest
    static void testTrigger(){
        Test.startTest();
        Contact newContact = [Select Id, Active__c From Contact Limit 1];
        newContact.Active__c = true;
        update newContact;
        delete newContact;
        List<Contact> deletedContacts = [SELECT Id, Active__c FROM Contact ALL ROWS];
        undelete deletedContacts;
        Test.stopTest();
    }
}
