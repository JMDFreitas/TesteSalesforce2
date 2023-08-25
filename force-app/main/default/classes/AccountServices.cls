public with sharing class AccountServices {
    public static void criarTarefasPorContas(List<Account> contas) {
        List<Task> tarefas = new List<Task>();
        for (Account acc : contas) {
            Task tarefa = new Task(
                Subject = Utils.buscarRecordTypeNamePorId('Account', acc.RecordTypeId),
                WhatId = acc.Id,
                Status = 'Not Started',
                Priority = 'Normal'
            );
            tarefas.add(tarefa);
        }
        Database.insert(tarefas);
    }

    public static void criarOportunidadesPorContas(List<Account> contas) {
        List<Opportunity> opps = new List<Opportunity>();
        for (Account acc : contas) {
            Opportunity opp = new Opportunity(
                Name = acc.Name + ' - opp Parceiro',
                StageName = 'Qualification',
                CloseDate = Date.today().addDays(30),
                AccountId = acc.Id
            );
            opps.add(opp);
        }
        Database.insert(opps);
    }
}