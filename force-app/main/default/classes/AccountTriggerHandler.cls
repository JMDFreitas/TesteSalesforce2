public with sharing class AccountTriggerHandler {
    public class AccountTriggerHandlerException extends Exception {
    }

    public static void beforeInsertHandler(List<Account> contasNovas) {
        for (Account acc : contasNovas) {
            try {
                if (Utils.validarCPF(acc.AccountNumber) || Utils.validarCNPJ(acc.AccountNumber)) {
                    System.debug('Cheguei aqui');
                    continue;
                }
                throw new AccountTriggerHandlerException(label.ACCOUNT_NUMBER_ERROR);
            } catch (Exception ex) {
                acc.addError('AccountNumber', ex.getMessage());
            }
        }
    }

    public static void afterInsertHandler(List<Account> contasNovas) {
        List<Account> contasParceiro = new List<Account>();
        List<Account> contasConsumidorFinal = new List<Account>();
        for (Account acc : contasNovas) {
            if (acc.RecordTypeId == AccountConstants.RECORDTYPEID_PARCEIRO) {
                System.debug('Estou no if de RT parceiro');
                contasParceiro.add(acc);
            }
            if (acc.RecordTypeId == AccountConstants.RECORDTYPEID_CONSUMIDOR_FINAL) {
                System.debug('Estou no if de RT consumidor');
                contasConsumidorFinal.add(acc);
            }
        }
        if (contasParceiro.isEmpty() && contasConsumidorFinal.isEmpty()) {

            return;
        }
        AccountServices.criarOportunidadesPorContas(contasParceiro);
        AccountServices.criarTarefasPorContas(contasConsumidorFinal);
    }
}