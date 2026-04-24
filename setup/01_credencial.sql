-- =============================================================================
-- Criação de Credencial OCI
-- =============================================================================
-- Registra as credenciais da API OCI no banco de dados para que os pacotes
-- DBMS_CLOUD e DBMS_CLOUD_OCI possam autenticar chamadas à API REST da Oracle.
--
-- Pré-requisitos:
--   1. Ter uma chave de API gerada no console OCI (Identity > Users > API Keys)
--   2. A chave privada deve ser copiada SEM os delimitadores:
--        -----BEGIN PRIVATE KEY-----
--        -----END PRIVATE KEY-----
-- =============================================================================

BEGIN
    DBMS_CLOUD.CREATE_CREDENTIAL(
        credential_name => 'OCI_CREDENTIAL',          -- nome de referência usado nos demais scripts
        user_ocid       => 'ocid1.user.oc1..xxxxx',   -- OCID do usuário OCI
        tenancy_ocid    => 'ocid1.tenancy.oc1..xxxxx', -- OCID da tenancy
        private_key     => '<conteúdo da chave privada PEM>',  -- chave RSA privada (sem cabeçalho/rodapé)
        fingerprint     => 'aa:bb:cc:...'              -- fingerprint da chave cadastrada no console OCI
    );
END;
/
