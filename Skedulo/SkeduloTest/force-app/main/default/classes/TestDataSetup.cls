@isTest
public with sharing class TestDataSetup {
    
    public static void generateContacts(){
        Contact contactTest = new Contact(FirstName='Richard', LastName='Hendricks');
        insert contactTest;
    }

    public static void generateAccounts(){
        Account accountTest = new Account(Name='Richard and Son Co');
        insert accountTest;
    }

    public static void generateAccountsContacts(){
        Account accountTest = new Account(Name='Better Call Saul');
        insert accountTest;
        Contact contactTest = new Contact(FirstName='Jimmy', LastName='McGill', AccountId = accountTest.Id);
        insert contactTest;
    }
}
