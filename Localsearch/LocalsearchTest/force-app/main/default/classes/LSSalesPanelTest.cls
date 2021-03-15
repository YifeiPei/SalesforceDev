@IsTest
private class LSSalesPanelTest {
    @TestSetup
    static void makeData(){
        Lead testLead = new Lead ();
        testLead.lastName = 'No One';
        testLead.Company = 'No Place';
        testLead.Status = [SELECT MasterLabel FROM LeadStatus WHERE IsDefault = true LIMIT 1].MasterLabel;
        testLead.Due_Date__c = Date.today().addMonths(1);
        Opportunity testOpp = new Opportunity ();
        testOpp.Name = 'Whatever';
        testOpp.StageName = 'Prospecting';
        testOpp.CloseDate = Date.today().addMonths(1);
        insert testLead;
        insert testOpp;
    }

    @IsTest
    static void test_getData () {
        Test.startTest();
        LSSalesPanelCtrl newSalesPanel = new LSSalesPanelCtrl ();
        LSSalesPanelHelper newSalesPanelHelper = new LSSalesPanelHelper ();
        List<LSSalesPanelHelper.salesInfo> dataResponse = LSSalesPanelCtrl.getData();
        Test.stopTest();
    }

    @IsTest
    static void test_convertLeads () {
        Test.startTest();
        List<Id> testIdList = new List<Id> ();
        testIdList.add([Select Id from Lead Limit 1].Id);
        String convertResponse = LSSalesPanelCtrl.convertLeads(JSON.serialize(testIdList));
        Test.stopTest();
    }

    @IsTest
    static void test_otherFunctions () {
        Test.startTest();
        List<Id> testIdList = new List<Id> ();
        testIdList.add([Select Id from Opportunity Limit 1].Id);
        String cloneResponse = LSSalesPanelCtrl.cloneRecords(JSON.serialize(testIdList));
        String deleteResponse = LSSalesPanelCtrl.deleteRecords(JSON.serialize(testIdList));
        Test.stopTest();
    }

    @IsTest
    static void test_exceptions () {
        Exception capturedException;
        List<Id> testIdList = new List<Id> ();
        testIdList.add([Select Id from Lead Limit 1].Id);
        testIdList.add([Select Id from Opportunity Limit 1].Id);
        try {
            String convertResponse = LSSalesPanelCtrl.convertLeads(JSON.serialize(testIdList));
        } catch (Exception e) {
            capturedException = e;
        }
        List<Id> testIdList1 = new List<Id> ();
        testIdList1.add([Select Id from Lead Limit 1].Id);
        String convertResponse = LSSalesPanelCtrl.convertLeads(JSON.serialize(testIdList1));
        try {
            String cloneResponse = LSSalesPanelCtrl.cloneRecords(JSON.serialize(testIdList1));
        } catch (Exception e) {
            capturedException = e;
        }
    }
}
