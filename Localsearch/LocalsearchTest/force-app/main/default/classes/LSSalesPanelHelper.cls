public with sharing class LSSalesPanelHelper {
    public LSSalesPanelHelper() {

    }

    private static List<Lead> getLeadRecords() {
        return [Select Id,Company,Status,Due_Date__c From Lead Where OwnerId = :UserInfo.getUserId() Order by Due_Date__c ASC];
    }

    private static List<Opportunity> getOpportunityRecords() {
        return [Select Id,Account.Name,StageName,CloseDate From Opportunity Where OwnerId = :UserInfo.getUserId() Order by CloseDate ASC];
    }

    public static List<salesInfo> getRecords() {
        List<salesInfo> newResposne = new List<salesInfo> ();
        List<Lead> leadRecords = getLeadRecords();
        List<Opportunity> opportunityRecords = getOpportunityRecords();

        if (!leadRecords.isEmpty()) {
            for (Lead leadRecord : leadRecords) {
                salesInfo newRecord = new salesInfo ();
                Id leadId = leadRecord.Id;
                newRecord.id = leadRecord.Id;
                newRecord.businessName = leadRecord.Company;
                newRecord.type = leadId.getSObjectType().getDescribe().getName();
                newRecord.status = leadRecord.Status;
                newRecord.dueDate = leadRecord.Due_Date__c;
                newResposne.add(newRecord);
            }
        }

        if (!opportunityRecords.isEmpty()) {
            for (Opportunity opportunityRecord : opportunityRecords) {
                salesInfo newRecord = new salesInfo ();
                Id opportunityId = opportunityRecord.Id;
                newRecord.id = opportunityRecord.Id;
                newRecord.businessName = opportunityRecord.Account.Name;
                newRecord.type = opportunityId.getSObjectType().getDescribe().getName();
                newRecord.status = opportunityRecord.StageName;
                newRecord.dueDate = opportunityRecord.CloseDate;
                newResposne.add(newRecord);
            }
        }

        return newResposne;
    }

    public static String leadConversion (List<Id> LeadIds) {
        String response = '';

        List<Database.LeadConvert> leadConverts = new list<Database.LeadConvert>();
        LeadStatus convertedStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        for(Id leadId: LeadIds) { 
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadId); 
            lc.setConvertedStatus(convertedStatus.MasterLabel);
            leadConverts.add(lc);
        }
        List<Database.LeadConvertResult> lcrList = Database.convertLead(leadConverts);
        for(Database.LeadConvertResult lcr : lcrList) {
            if (!lcr.isSuccess()) {
                response = lcr.errors.get(0).message;
            }
        }
        if (response == '')
            response = 'Success';
        
        return response;
    }

    public static String recordsClone (List<Id> RecordIds) {
        String response = '';
        Set<Id> leadIds = new Set<Id> ();
        Set<Id> oppIds = new Set<Id> ();

        for(Id recordId: RecordIds) {
            if (recordId.getSObjectType().getDescribe().getName() == 'Lead') 
                leadIds.add(recordId);
            if (recordId.getSObjectType().getDescribe().getName() == 'Opportunity') 
                oppIds.add(recordId);
        }

        if (leadIds.size() > 0) {
            String leadQuery = getCreatableFieldsSOQL('Lead') + 'leadIds';
            List<Lead> leadsToInsert = new List<Lead> ();
            List<Lead> leadCloneList = (List<Lead>)Database.query(leadQuery);
            for (Lead newLead : leadCloneList) {
                Lead clonedLead = newLead.clone(false, false, false, false);
                if (clonedLead.Due_Date__c == null) {
                    clonedLead.Due_Date__c = date.today().addYears(1);
                } else {
                    clonedLead.Due_Date__c = clonedLead.Due_Date__c.addYears(1);
                }
                leadsToInsert.add(clonedLead);
            }
            insert leadsToInsert;
        }
        if (oppIds.size() > 0) {
            String oppQuery = getCreatableFieldsSOQL('Opportunity') + 'oppIds';
            List<Opportunity> oppsToInsert = new List<Opportunity> ();
            List<Opportunity> oppCloneList = (List<Opportunity>)Database.query(oppQuery);
            for (Opportunity newOpp : oppCloneList) {
                Opportunity clonedOpp = newOpp.clone(false, false, false, false);
                clonedOpp.CloseDate = clonedOpp.CloseDate.addYears(1);
                oppsToInsert.add(clonedOpp);
            }
            insert oppsToInsert;
        }

        response = 'success';
        return response;
    }

    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName){
        String selects = '';
        
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}    
        }
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE id IN :';
    }

    public static String recordsDeletion (List<Id> RecordIds) {
        String response = '';
        Set<Id> leadIds = new Set<Id> ();
        Set<Id> oppIds = new Set<Id> ();

        for(Id recordId: RecordIds) {
            if (recordId.getSObjectType().getDescribe().getName() == 'Lead') 
                leadIds.add(recordId);
            if (recordId.getSObjectType().getDescribe().getName() == 'Opportunity') 
                oppIds.add(recordId);
        }

        if (leadIds.size() > 0) {
            List<Lead> leadsToDelete = [Select Id From Lead Where Id IN :leadIds];
            delete leadsToDelete;
        }
        if (oppIds.size() > 0) {
            List<Opportunity> oppsToDelete = [Select Id From Opportunity Where Id IN :oppIds];
            delete oppsToDelete;
        }

        response = 'success';
        return response;
    }

    public Class salesInfo {
        @AuraEnabled
        public String id;

        @AuraEnabled
        public String businessName;

        @AuraEnabled
        public String type;

        @AuraEnabled
        public String status;

        @AuraEnabled
        public Date dueDate;
    }
}