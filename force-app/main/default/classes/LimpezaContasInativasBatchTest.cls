@isTest
public with sharing class LimpezaContasInativasBatchTest {
    @TestSetup
    static void makeData() {
        //Primeiro cenario
        Account acc1 = new Account(Name = 'Conta Teste', Inativa__c = false);
        insert acc1;
        Task tarefa1 = new Task(Subject = 'Consumidor Final', WhatId = acc1.Id);
        insert tarefa1;
        Opportunity opp1 = new Opportunity(
            Name = 'Opp test',
            AccountId = acc1.Id,
            StageName = 'Closed Lost',
            CloseDate = Date.today().addDays(200)
        );
        insert opp1;

        //Segundo cenario
        Account acc2 = new Account(Name = 'Conta Teste 2', Inativa__c = false);
        insert acc2;
        Task tarefa2 = new Task(Subject = 'Consumidor Final', WhatId = acc2.Id);
        insert tarefa2;
        Opportunity opp2 = new Opportunity(
            Name = 'Opp test 2',
            AccountId = acc2.Id,
            StageName = 'Closed Won',
            CloseDate = Date.today().addDays(10)
        );
        insert opp2;

        //Terceiro cenario
        Account acc3 = new Account(Name = 'Conta Teste 3', Inativa__c = false);
        insert acc3;
        Opportunity opp3 = new Opportunity(
            Name = 'Opp test 3',
            AccountId = acc3.Id,
            StageName = 'Negotiation/Review',
            CloseDate = Date.today().addDays(15)
        );
        insert opp3;
    }
    @isTest
    static void testarBatch() {
        Id accId = [SELECT Id FROM Account WHERE Name = 'Conta Teste 2'].Id;
        Task tarefa2 = [SELECT Id FROM Task WHERE AccountId = :accId LIMIT 1];
        tarefa2.Status = 'Completed';
        update tarefa2;

        Test.startTest();
        new LimpezaContasInativasBatch().execute(null);
        Test.stopTest();
        List<Account> accsPosBatch = [SELECT Id, Name, Inativa__c FROM Account];
        for (Account acc : accsPosBatch) {
            if (acc.Name == 'Conta Teste') {
                Assert.isTrue(acc.Inativa__c, 'Deveria ter alterado o campo inativa pra true');
                continue;
            }
            Assert.isFalse(acc.Inativa__c, 'O campo inativa deveria esta false');
        }
    }
}