public with sharing class LimpezaContasInativasBatch implements Schedulable, Database.Batchable<SObject> {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(this, 100);
    }

    public Database.queryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id FROM Account';
        return Database.getQueryLocator(String.escapeSingleQuotes(query));
    }

    public void execute(Database.BatchableContext bc, List<Account> contas) {
        Map<Id, Account> mapAccount = new Map<Id, Account>(contas);
        Map<Id, Task> mapTask = new Map<Id, Task>(
            new List<Task>([SELECT Id, AccountId FROM Task WHERE AccountId IN :contas AND CompletedDateTime = LAST_90_DAYS])
        );
        Map<Id, Opportunity> mapOpp = new Map<Id, Opportunity>(
            new List<Opportunity>(
                [
                    SELECT Id, StageName, AccountId
                    FROM Opportunity
                    WHERE
                        AccountId IN :contas
                        AND ((StageName = 'Closed Won'
                        AND CloseDate = LAST_N_DAYS:120)
                        OR StageName = 'Negotiation/Review')
                ]
            )
        );

        for (Task tarefa : mapTask.values()) {
            mapAccount.remove(tarefa.AccountId);
        }
        for (Opportunity opp : mapOpp.values()) {
            mapAccount.remove(opp.AccountId);
        }
        for (Account acc : mapAccount.values()) {
            acc.Inativa__c = true;
        }
        Database.update(mapAccount.values());
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('LimpezaContasInativasBatch Finalizado');
    }
}