@isTest
public with sharing class ContactResourcesTest {

    @TestSetup
    static void makeData(){
        TestDataSetup.generateContacts();
    }

    @isTest
    static void testUpdateContact() {
        Test.startTest();
        Contact contactToUpdate = [SELECT Id FROM Contact LIMIT 1];
        List<Contact> newContactList = new List<Contact> ();
        Contact newContact1 = new Contact();
        newContact1.Id = contactToUpdate.Id;
        newContact1.FirstName = 'Gavin';
        newContactList.add(newContact1);
        Contact newContact2 = new Contact();
        newContact2.FirstName = 'Peter';
        newContact2.LastName = 'Parker';
        newContactList.add(newContact2);

        // Forming the request
        RestRequest contactRequest = new RestRequest();
        contactRequest.requestUri = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/ContactAPI/';
        contactRequest.httpMethod = 'PATCH';
        contactRequest.requestBody = Blob.valueOf(JSON.serialize(newContactList));
        RestContext.request = contactRequest;

        List<ContactResources.ResponseWrapper> returnedResponse = ContactResources.updateContacts();

        // Confirming the response
        Contact queriedContact = [SELECT FirstName, LastName FROM Contact WHERE Id =: contactToUpdate.Id];
        System.assertEquals('Gavin', queriedContact.FirstName);
        System.assertEquals('Hendricks', queriedContact.LastName);
        Test.stopTest();
    }
}
