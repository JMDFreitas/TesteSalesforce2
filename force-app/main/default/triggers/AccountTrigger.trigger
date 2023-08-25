trigger AccountTrigger on Account(before insert, after insert) {
    switch on Trigger.OperationType {
        when BEFORE_INSERT {
            AccountTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when AFTER_INSERT {
            AccountTriggerHandler.afterInsertHandler(Trigger.new);
        }
    }

}