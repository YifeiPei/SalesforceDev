@RestResource(urlMapping = '/ContactAPI/*')
global with sharing class ContactResources{
	global class ResponseWrapper{
		String success;
		String message;
	}

	@HTTPPatch
	global static List<ResponseWrapper> updateContacts(){
		List<ResponseWrapper> responseWrapperList = new List<ResponseWrapper>();
		RestRequest contactsRequest = RestContext.request;
		String requestBody = contactsRequest.requestBody.toString();
		List<Contact> contactsToUpdate = (List<Contact>)JSON.deserialize(requestBody, List<Contact>.class);
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