@isTest
public class BaseTriggerHandlerTest {
    @isTest
    static void ExecuteWithBeforeInsertContext_ExecutesBeforeInsert() {
        // Arrange
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.context = Enums.TriggerContext.BEFORE_INSERT;

        // Act
        handler.run();

        // Assert
        System.assertEquals(Enums.TriggerContext.BEFORE_INSERT, handler.executedContext);
    }

    @isTest
    static void ExecuteWithAfterInsertContext_ExecutesAfterInsert() {
        // Arrange
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.context = Enums.TriggerContext.AFTER_INSERT;

        // Act
        handler.run();

        // Assert
        System.assertEquals(Enums.TriggerContext.AFTER_INSERT, handler.executedContext);
    }

    @isTest
    static void ExecuteWithBeforeUpdateContext_ExecutesBeforeUpdate() {
        // Arrange
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.context = Enums.TriggerContext.BEFORE_UPDATE;

        // Act
        handler.run();

        // Assert
        System.assertEquals(Enums.TriggerContext.BEFORE_UPDATE, handler.executedContext);
    }

    @isTest
    static void ExecuteWithAfterUpdateContext_ExecutesAfterUpdate() {
        // Arrange
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.context = Enums.TriggerContext.AFTER_UPDATE;

        // Act
        handler.run();

        // Assert
        System.assertEquals(Enums.TriggerContext.AFTER_UPDATE, handler.executedContext);
    }

    @isTest
    static void ExecuteWithAfterUpdateContextAndException_ExecutesAfterUpdateAndExcepionThrown() {
        // Arrange
        String errorMsg = '';
        TestTriggerHandler handler = new TestTriggerHandler(true);
        handler.context = Enums.TriggerContext.AFTER_UPDATE;

        // Act
        try {
            handler.run();
        } catch (Exception ex) {
           errorMsg = ex.getMessage();
        }

        // Assert
        System.assertEquals(Enums.TriggerContext.AFTER_UPDATE, handler.executedContext);
        System.assertEquals(true, errorMsg.contains('Test application exception') , 'Unexpected exception error message returned');
    }

    @isTest
    static void ExecuteWithBeforeDeleteContext_ExecutesBeforeDelete() {
        // Arrange
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.context = Enums.TriggerContext.BEFORE_DELETE;

        // Act
        handler.run();

        // Assert
        System.assertEquals(Enums.TriggerContext.BEFORE_DELETE, handler.executedContext);
    }

    @isTest
    static void ExecuteWithAfterDeleteContext_ExecutesAfterDelete() {
        // Arrange
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.context = Enums.TriggerContext.AFTER_DELETE;

        // Act
        handler.run();

        // Assert
        System.assertEquals(Enums.TriggerContext.AFTER_DELETE, handler.executedContext);
    }

    @isTest
    static void ExecuteWithAfterUndeleteContext_ExecutesAfterUndelete() {
        // Arrange
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.context = Enums.TriggerContext.AFTER_UNDELETE;

        // Act
        handler.run();

        // Assert
        System.assertEquals(Enums.TriggerContext.AFTER_UNDELETE, handler.executedContext);
    }

    public class TestTriggerHandler extends BaseTriggerHandler {
        public Enums.TriggerContext executedContext;
        private Boolean throwException = false;

        public TestTriggerHandler() {

        }

        public TestTriggerHandler(Boolean throwException) {
            this.throwException = throwException;
        }

        protected override void beforeInsert() {
            this.executedContext = Enums.TriggerContext.BEFORE_INSERT;
        }

        protected override void beforeUpdate() {
            this.executedContext = Enums.TriggerContext.BEFORE_UPDATE;
        }

        protected override void beforeDelete() {
            this.executedContext = Enums.TriggerContext.BEFORE_DELETE;
        }

        protected override void afterInsert() {
            this.executedContext = Enums.TriggerContext.AFTER_INSERT;
        }

        protected override void afterUpdate() {
            this.executedContext = Enums.TriggerContext.AFTER_UPDATE;

            if (this.throwException)
                throw new Exceptions.ApplicationException('Test application exception');
        }

        protected override void afterDelete() {
            this.executedContext = Enums.TriggerContext.AFTER_DELETE;
        }
        
        protected override void afterUndelete() {
            this.executedContext = Enums.TriggerContext.AFTER_UNDELETE;
        }
    }
}