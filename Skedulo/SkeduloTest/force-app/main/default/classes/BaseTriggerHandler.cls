public abstract class BaseTriggerHandler {
    protected Exception exc;
    protected String className;
    private Enums.TriggerContext overrideContext;

    public Enums.TriggerContext context {
        get {
            if (overrideContext != null)
                return overrideContext;
            
            if (Trigger.isExecuting) {
                if (Trigger.isBefore && Trigger.isInsert)
                    return Enums.TriggerContext.BEFORE_INSERT;
                
                if (Trigger.isBefore && Trigger.isUpdate)
                    return Enums.TriggerContext.BEFORE_UPDATE;
                
                if (Trigger.isBefore && Trigger.isDelete)
                    return Enums.TriggerContext.BEFORE_DELETE;
                
                if (Trigger.isAfter && Trigger.isInsert)
                    return Enums.TriggerContext.AFTER_INSERT;
                
                if (Trigger.isAfter && Trigger.isUpdate)
                    return Enums.TriggerContext.AFTER_UPDATE;
                
                if (Trigger.isAfter && Trigger.isDelete)
                    return Enums.TriggerContext.AFTER_DELETE;
                
                if(Trigger.isAfter && Trigger.isUndelete)
                    return Enums.TriggerContext.AFTER_UNDELETE;
            }

            return null;
        }
        set {
            overrideContext = value;
        }
    }

    public BaseTriggerHandler() {
        this.className = String.valueOf(this).split(':')[0];
    }

    protected virtual void beforeInsert() {

    }

    protected virtual void beforeUpdate() {

    }

    protected virtual void beforeDelete() {

    }

    protected virtual void afterInsert() {

    }

    protected virtual void afterUpdate() {

    }

    protected virtual void afterDelete() {

    }

    protected virtual void afterUndelete() {

    }

    public void run() {
        Boolean isValid = true;

        // Execution validation
        if (Trigger.isExecuting == false && this.overrideContext == null) {
            exc = new Exceptions.TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }

        if (context == null) {
            exc = new Exceptions.TriggerHandlerException('Unable to determine the context this trigger handler is being executed in');
        }

        // Data loading check
        if (UserInfo.getName() == 'Data Migration User') {
              Log.info(this.className, 'run', 'Skipping execution of {0} trigger handler. Executed by a Data Loader profile user.');
              isValid = false;
        }

        if (isValid) {
            try {
                // Dispatch to the correct handler method
                Log.info(this.className, 'run', 'Starting execution of ' + String.valueOf(context) + ' context.');

                if (context == Enums.TriggerContext.BEFORE_INSERT) {
                    this.beforeInsert();
                } else if (context == Enums.TriggerContext.BEFORE_UPDATE) {
                    this.beforeUpdate();
                } else if (context == Enums.TriggerContext.BEFORE_DELETE) {
                    this.beforeDelete();
                } else if (context == Enums.TriggerContext.AFTER_INSERT) {
                    this.afterInsert();
                } else if (context == Enums.TriggerContext.AFTER_UPDATE) {
                    this.afterUpdate();
                } else if (context == Enums.TriggerContext.AFTER_DELETE) {
                    this.afterDelete();
                } else if (context == Enums.TriggerContext.AFTER_UNDELETE) {
                    this.afterUndelete();
                }
                
                Log.info(this.className, 'run', 'Finished execution of ' + String.valueOf(context) + ' context.');
            } catch(Exception ex) {
                exc = ex;
                Log.error(this.className, 'run', ex.getMessage());
            }
        }
        if (exc != null)
            throw exc;
    }
}