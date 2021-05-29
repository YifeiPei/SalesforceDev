public with sharing class accConSearchCtrl{
	public List<outputModel> outPut{get;set;}
	public String searchKey{get;set;}

	public accConSearchCtrl(){
		outPut = new List<outputModel>();
	}

	public void search(){
		outPut = new List<outputModel>();
		List<Account> accRecords = getAccRecords(searchKey);
		List<Contact> conRecords = getConRecords(searchKey);
		for (Account accRecord : accRecords){
			outPut.add(new outputModel(accRecord));
		}
		for (Contact conRecord : conRecords){
			outPut.add(new outputModel(conRecord));
		}
	}

    public void clear(){
        searchKey = '';
        outPut.clear();
    }

	// search function only search on starting strings
	// as Account Name and Contact Name are case-insensitive fields, the soql search is automatically case-insensitive
	private static List<Account> getAccRecords(String keyWord){
		return [Select Id, Name
		        From Account
		        Where Name Like :keyWord + '%'];
	}
	private static List<Contact> getConRecords(String keyWord){
		return [Select Id, Name
		        From Contact
		        Where Name Like :keyWord + '%'];
	}

	public Class outputModel{
		public String id{get;set;}
		public String name{get;set;}
		public String type{get;set;}

		public outputModel(Account accRecord){
			Id accId = accRecord.Id;
			this.id = accRecord.Id;
			this.name = accRecord.Name;
			this.type = accId.getSObjectType().getDescribe().getName();
		}

		public outputModel(Contact conRecord){
			Id conId = conRecord.Id;
			this.id = conRecord.Id;
			this.name = conRecord.Name;
			this.type = conId.getSObjectType().getDescribe().getName();
		}
	}
}