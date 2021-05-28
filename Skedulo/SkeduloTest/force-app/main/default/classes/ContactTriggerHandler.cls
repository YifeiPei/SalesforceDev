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
	}

	public override void afterDelete(){
	}

	public override void afterUndelete(){
	}
}