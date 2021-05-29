public class ContactTriggerHandler extends BaseTriggerHandler{
	public override void beforeInsert(){
	}

	public override void beforeUpdate(){
	}

	public override void beforeDelete(){
	}

	public override void afterInsert(){
		ContactTriggerService.triggerApprovalProcess(Trigger.new, Trigger.oldMap, Enums.TriggerContext.AFTER_INSERT);
	}

	public override void afterUpdate(){
		ContactTriggerService.sumContacts(Trigger.new, Trigger.oldMap, Enums.TriggerContext.AFTER_UPDATE);
	}

	public override void afterDelete(){
		ContactTriggerService.sumContacts(Trigger.new, Trigger.oldMap, Enums.TriggerContext.AFTER_DELETE);
	}

	public override void afterUndelete(){
		ContactTriggerService.sumContacts(Trigger.new, Trigger.oldMap, Enums.TriggerContext.AFTER_UNDELETE);
	}
}