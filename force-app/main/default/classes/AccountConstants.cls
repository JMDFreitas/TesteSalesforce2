public with sharing class AccountConstants {
    public static final Id RECORDTYPEID_PARCEIRO {
        get {
            if (RECORDTYPEID_PARCEIRO == null) {
                RECORDTYPEID_PARCEIRO = Utils.buscarRecordTypeIdPorNome('Account', 'Parceiro');
            }
            return RECORDTYPEID_PARCEIRO;
        }
        private set;
    }

    public static final Id RECORDTYPEID_CONSUMIDOR_FINAL {
        get {
            if (RECORDTYPEID_CONSUMIDOR_FINAL == null) {
                RECORDTYPEID_CONSUMIDOR_FINAL = Utils.buscarRecordTypeIdPorNome('Account', 'ConsumidorFinal');
            }
            return RECORDTYPEID_CONSUMIDOR_FINAL;
        }
        private set;
    }
}