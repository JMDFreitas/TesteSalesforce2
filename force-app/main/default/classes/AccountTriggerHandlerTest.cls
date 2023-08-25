@isTest
public class AccountTriggerHandlerTest {
    @isTest
    static void criarContaComCPFvalidoTeste() {
        Account contaCPFValido = new Account(Name = 'Conta CPF Válido', AccountNumber = '78127935085');

        Test.startTest();
        insert contaCPFValido;
        Test.stopTest();

        List<Account> contasInseridas = [SELECT Id FROM Account WHERE AccountNumber = '78127935085'];
        Assert.isTrue(contasInseridas.size() == 1, 'A conta não foi inserida com sucesso!');
    }

    @isTest
    static void criarContaComCPFOUCNPJNuloTeste() {
        Account contaCPFValido = new Account(Name = 'Conta CPF Válido', AccountNumber = null);

        Test.startTest();
        insert contaCPFValido;
        Test.stopTest();

        List<Account> contasInseridas = [SELECT Id FROM Account];
        Assert.isTrue(contasInseridas.size() == 1, 'A conta não foi inserida com sucesso!');
    }

    @isTest
    static void criarContaComCPFInvalidoEntaoRetornaErroTeste() {
        String erro;
        Account contaCPFInvalido = new Account(Name = 'Conta CPF Invalido', AccountNumber = '781279350');

        Test.startTest();
        try {
            insert contaCPFInvalido;
        } catch (Exception ex) {
            erro = ex.getMessage();
        }
        Test.stopTest();
        List<Account> contasInseridas = [SELECT Id FROM Account];
        Assert.isTrue(contaCPFInvalido.hasErrors(), 'Não houve erro ao inserir o registro!');
        Assert.isTrue(erro.contains(label.ACCOUNT_NUMBER_ERROR));
        Assert.isTrue(contasInseridas.size() == 0, 'A conta não deve ser inserida!');
    }

    @isTest
    static void criarContaComCNPJvalidoTeste() {
        Account contaCPFValido = new Account(Name = 'Conta CPF Válido', AccountNumber = '28124810000179');

        Test.startTest();
        insert contaCPFValido;
        Test.stopTest();

        List<Account> contasInseridas = [SELECT Id FROM Account WHERE AccountNumber = '28124810000179'];
        Assert.isTrue(contasInseridas.size() == 1, 'A conta não foi inserida com sucesso!');
    }

    @isTest
    static void criarContaComCNPJnvalidoEntaoRetornaErroTeste() {
        String erro;
        Account contaCPFInvalido = new Account(Name = 'Conta CPF Invalido', AccountNumber = '281248100001799999');

        Test.startTest();
        try {
            insert contaCPFInvalido;
        } catch (Exception ex) {
            erro = ex.getMessage();
        }
        Test.stopTest();
        List<Account> contasInseridas = [SELECT Id FROM Account];
        Assert.isTrue(contaCPFInvalido.hasErrors(), 'Não houve erro ao inserir o registro!');
        Assert.isTrue(erro.contains(label.ACCOUNT_NUMBER_ERROR));
        Assert.isTrue(contasInseridas.size() == 0, 'A conta não deve ser inserida!');
    }

    @isTest
    static void criarContaComAccountNUmberValidoEntaoEmLoteEntaoInsereTeste() {
        String erro;
        Account contaCNPJ1 = new Account(Name = 'Conta CNPJ 1', AccountNumber = '28124810000179');
        Account contaCNPJ2 = new Account(Name = 'Conta CNPJ 2', AccountNumber = '98603418000198');
        Account contaCPF1 = new Account(Name = 'Conta CPF 1', AccountNumber = '18317441040');
        Account contaCPF2 = new Account(Name = 'Conta CPF 2', AccountNumber = '95940011004');

        Test.startTest();

        insert new List<Account>{ contaCNPJ1, contaCNPJ2, contaCPF1, contaCPF2 };

        Test.stopTest();
        List<Account> contasInseridas = [SELECT Id FROM Account];

        Assert.isTrue(contasInseridas.size() == 4, 'A conta não deve ser inserida!');
    }

    @isTest
    static void criarOportunidadeQuandoContaForParceiroTest() {
        Account conta = new Account(
            Name = 'Conta Test',
            AccountNumber = '28124810000179',
            RecordTypeId = AccountConstants.RECORDTYPEID_PARCEIRO
        );
        Test.startTest();
        insert conta;
        Test.stopTest();
        Opportunity opp = [SELECT Id, CloseDate, Name, StageName FROM Opportunity WHERE AccountId = :conta.Id LIMIT 1];

        Assert.isNotNull(opp.CloseDate, 'a data deve está preenchida');
        Assert.isTrue(opp.StageName == 'Qualification', 'O estagio está diferente de Qualification');
        Assert.isTrue(opp.Name.contains('Parceiro'), 'O nome da oportunidade deve conter a palavra Parceiro');
    }

    @isTest
    static void quandoContaForDiferenteDeParceiroNaoCriaOppTest() {
        Account conta = new Account(
            Name = 'Conta Test',
            AccountNumber = '28124810000179',
            RecordTypeId = AccountConstants.RECORDTYPEID_CONSUMIDOR_FINAL
        );
        Test.startTest();
        insert conta;
        Test.stopTest();
        List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE AccountId = :conta.Id LIMIT 1];

        Assert.isTrue(opps.size() == 0, 'Não deve ter criado Oportunidade');
    }

    @isTest
    static void criarTarefaQuandoContaForConsumidorFinalTest() {
        Account conta = new Account(
            Name = 'Conta Test',
            AccountNumber = '28124810000179',
            RecordTypeId = AccountConstants.RECORDTYPEID_CONSUMIDOR_FINAL
        );
        Test.startTest();
        insert conta;
        Test.stopTest();
        Task tarefa = [SELECT Id, Subject, Status, Priority FROM Task WHERE WhatId = :conta.Id LIMIT 1];

        Assert.isTrue(tarefa.Subject == 'Consumidor Final', 'O subject foi preenchido de forma errada');
        Assert.isTrue(tarefa.Status == 'Not Started', 'O status está diferente de Not Started');
        Assert.isTrue(tarefa.Priority == 'Normal', 'A priority esta diferente de Normal');
    }

    @isTest
    static void quandoRecordTypeForVazioNaoCriaOppTaskTest() {
        Account conta = new Account(Name = 'Conta Test', AccountNumber = '28124810000179');
        Test.startTest();
        insert conta;
        Test.stopTest();
        List<Task> tarefas = [SELECT Id, Subject, Status, Priority FROM Task];
        List<Opportunity> opps = [SELECT Id FROM Opportunity];

        Assert.isTrue(tarefas.size() == 0, 'Não deve criar tarefas');
        Assert.isTrue(opps.size() == 0, 'Não deve criar oportunidades');
    }
}