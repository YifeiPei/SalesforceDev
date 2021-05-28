public with sharing class ContactTriggerService{
	public static void triggerApprovalProcess(List<SObject> items, Map<Id, SObject> oldMap, Enums.TriggerContext triggerContext){
		// Contact.Active__c field is not put in page layout to make sure at creating the contact, user will not flag it as true
		// make sure the approval process will be triggered after creation
		if (triggerContext == Enums.TriggerContext.AFTER_INSERT){
			Approval.ProcessSubmitRequest[] requestList = new Approval.ProcessSubmitRequest[]{};
			for (Contact newContact : (List<Contact>)items){
				// Only trigger the approval process when the contact is associated with Account
				if (newContact.AccountId != null){
					Approval.ProcessSubmitRequest newReq = new Approval.ProcessSubmitRequest();
					newReq.setComments('Submitting request for approval.');
					newReq.setObjectId(newContact.id);
					newReq.setProcessDefinitionNameOrId('Activate_Contact');
					newReq.setSkipEntryCriteria(true);
					// in the real practice, this approver should be a real approver picked up by the code
					// to make it easier for testing, I just made the submitter the approver
					newReq.setNextApproverIds(new Id[]{UserInfo.getUserId()});
					requestList.add(newReq);
				}
			}
			if (requestList.size() > 0){
				Approval.ProcessResult[] results = Approval.process(requestList);
                // for debug purpose
				System.debug('results: ' + results);
				for (Approval.ProcessResult result : results){
					System.assert(result.isSuccess());
					System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status' + result.getInstanceStatus());
				}
			}
		}
	}
}