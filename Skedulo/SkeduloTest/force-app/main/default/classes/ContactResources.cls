@RestResource(urlMapping = '/ContactAPI/*')
global with sharing class ContactResources{
	global class ResponseWrapper{
		String success;
		String message;
	}

	@HTTPPatch
	global static List<ResponseWrapper> updateContacts(){
        /* Assumption: To update contact records, the payload must have contact Ids specified
         * otherwise no matter we have Contact.Name or Contact.Email, contacts cannot be precisely located
         * Contacts with the same Name and Email Address may not be the ones that we want to update*/
		List<ResponseWrapper> responseWrapperList = new List<ResponseWrapper>();
		RestRequest contactsRequest = RestContext.request;
		String requestBody = contactsRequest.requestBody.toString();
		List<Contact> contactsToUpdate = (List<Contact>)JSON.deserialize(requestBody, List<Contact>.class);
        /* When we are using Database.SaveResult, each update error is already recorded in the response
         * Therefore we do not need a specific validation to check if the contact ids exist
         * If the required Id field is missing, the error message will be sent to the requestor */
		Database.SaveResult[] updateResults = Database.update(contactsToUpdate, false);
		for (Database.SaveResult updateResult : updateResults){
			ResponseWrapper wrapper = new ResponseWrapper();
			if (updateResult.isSuccess()){
				wrapper.success = '1';
				wrapper.message = 'Successfully updated contact with Id: ' + updateResult.getId();
			} else{
				wrapper.success = '0';
				for (Database.Error error : updateResult.getErrors()){
					wrapper.message = 'The following error has occurred for contact with Id: ' + updateResult.getId()+'. ';
					wrapper.message += error.getStatusCode()+': ' + error.getMessage()+'. ';
					wrapper.message += 'Contact fields that affected this error: ' + error.getFields();
				}
			}
			responseWrapperList.add(wrapper);
		}
		return responseWrapperList;
	}
}