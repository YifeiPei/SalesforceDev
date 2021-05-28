public with sharing class ContactTriggerService{
	public static void triggerApprovalProcess(List<SObject> items, Map<Id, SObject> oldMap, Enums.TriggerContext triggerContext){
		//Request for all opportunity
		Approval.ProcessSubmitRequest[] requestList = new Approval.ProcessSubmitRequest[]{};

		for (Contact newContact : (List<Contact>)items){
			// Create an approval request for the opportunity
			Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
			req1.setComments('Submitting request for approval.');
			req1.setObjectId(newContact.id);

			// Submit the record to specific process
			req1.setProcessDefinitionNameOrId('Activate_Contact');
			req1.setSkipEntryCriteria(true);
			req1.setNextApproverIds(new Id[]{UserInfo.getUserId()});
			requestList.add(req1);
		}

		if (requestList.size() > 0){
			// Submit the approval request for the opportunity
			Approval.ProcessResult[] result = Approval.process(requestList);
			System.debug('result: ' + result);
		}
	}
}