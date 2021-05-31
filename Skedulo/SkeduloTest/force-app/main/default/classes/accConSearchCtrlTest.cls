@isTest
public with sharing class accConSearchCtrlTest {

    @TestSetup
    static void makeData(){
        TestDataSetup.generateAccounts();
        TestDataSetup.generateContacts();
    }

    @isTest
    static void testController(){
        Test.startTest();
        accConSearchCtrl newController = new accConSearchCtrl ();
        newController.searchKey = 'Richard';
        newController.search();
        newController.clear();
        accConSearchHelper newHelper = new accConSearchHelper (newController);
        Account newAccount = [Select Id From Account Limit 1];
        Contact newContact = [Select Id From Contact Limit 1];
        String accResponse = accConSearchHelper.addCounter(newAccount.Id, 'Account', 0);
        String conResponse = accConSearchHelper.addCounter(newContact.Id, 'Contact', 1);
        Exception capturedException;
        try {
            String errorResponse = accConSearchHelper.addCounter('wrongId', 'Account', 2);
        } catch (Exception e) {
            capturedException = e;
        }
        Test.stopTest();
    }
}
