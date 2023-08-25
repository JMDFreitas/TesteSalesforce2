public class Utils {
    public static Boolean validarCPF(String cpf) {
        if (cpf?.length() == 11 || String.isEmpty(cpf)) {
            return true;
        }
        return false;
    }

    public static Boolean validarCNPJ(String cnpj) {
        if (cnpj?.length() == 14 || String.isEmpty(cnpj)) {
            return true;
        }
        return false;
    }

    public static Id buscarRecordTypeIdPorNome(String nomeObjeto, String nomeRecordType) {
        return Schema.getGlobalDescribe()
            .get(nomeObjeto)
            .getDescribe()
            .getRecordTypeInfosByDeveloperName()
            .get(nomeRecordType)
            .getRecordTypeId();
    }

    public static String buscarRecordTypeNamePorId(String nomeObjeto, Id recordTypeId) {
        return Schema.getGlobalDescribe().get(nomeObjeto).getDescribe().getRecordTypeInfosById().get(recordTypeId).getName();
    }
}