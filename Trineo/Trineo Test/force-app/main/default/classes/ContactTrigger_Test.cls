@isTest
public class ContactTrigger_Test {
    @isTest static void createContact() {
        createTestingDate();
        Contact theAUContact = new Contact(LastName = 'Smith');
        Contact theNZContact = new Contact(LastName = 'Tom');
        Id AUType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Australia').getRecordTypeId();
        theAUContact.RecordtypeId= AUType;
        Id NZType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('New Zealand').getRecordTypeId();
        theNZContact.RecordtypeId= NZType;
        List <Contact> contactsToInsert = new List <Contact> ();
        contactsToInsert.add(theAUContact);
        contactsToInsert.add(theNZContact);
        try {
            insert contactsToInsert;
            System.debug('theAUContact: ' + theAUContact);
            System.debug('theNZContact: ' + theNZContact);
        } catch (Exception e) {
            
        }
    }
    
    static void createTestingDate() {
        Account accountAU = new Account (Name = 'Australia');
        Account accountNZ = new Account (Name = 'New Zealand');
        List <Account> accountsToInsert = new List <Account> ();
        accountsToInsert.add(accountAU);
        accountsToInsert.add(accountNZ);
        insert accountsToInsert;
    }
}