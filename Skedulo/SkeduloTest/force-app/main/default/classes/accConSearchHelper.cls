global with sharing class accConSearchHelper {
    public accConSearchHelper(accConSearchCtrl ctrlParam) {

    }

    @RemoteAction
    global static String addCounter (String recordId, String recordType, Integer index) {
        String counterResponse = '';
        counterResponse newResponse = new counterResponse ();
        // Assumption: this function will always update one record only
        System.debug('recordId: ' + recordId);
        System.debug('recordType: ' + recordType);
        System.debug('index: ' + index);
        try {
            String query = 'Select Id, Counter__c From '+recordType+' Where Id = \''+recordId+'\'';
            SObject recordToUpdate = Database.query(query);
            System.debug('recordToUpdate: ' + recordToUpdate);
            // assumption: Counter__c is always not null as it has a default value
            // All the records that pre exist the field was created will be mass updated by the executer after Counter__c field is created
            if (recordType == 'Account') {
                Account accountToUpdate = (Account)recordToUpdate;
                accountToUpdate.Counter__c += 1;
                update accountToUpdate;
                newResponse.counter = Integer.valueOf(accountToUpdate.Counter__c);
            } else if (recordType == 'Contact') {
                Contact contactToUpdate = (Contact)recordToUpdate;
                contactToUpdate.Counter__c += 1;
                update contactToUpdate;
                newResponse.counter = Integer.valueOf(contactToUpdate.Counter__c);
            }
            newResponse.index = index;
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage() + ' ' + e.getLineNumber());
            newResponse.errorMessage = e.getMessage();
        }
        counterResponse = JSON.serialize(newResponse);
        System.debug('counterResponse: ' + counterResponse);
        return counterResponse;
    }

    public Class counterResponse{
        public Integer counter{get;set;}
        public Integer index{get;set;}
        public String errorMessage{get;set;}
    }
}