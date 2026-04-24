-- =============================================================================
-- Listar Instâncias de Compute — OCI Compute
-- =============================================================================
-- Chama a API OCI Compute via DBMS_CLOUD_OCI_CR_COMPUTE para listar todas as
-- instâncias de um compartimento. Exibe nome, OCID, shape, status, AD e região.
--
-- Pré-requisito: credencial criada em setup/01_credencial.sql
-- =============================================================================

SET SERVEROUTPUT ON;

DECLARE
    -- Objeto de resposta HTTP retornado pela chamada à API OCI
    l_response  DBMS_CLOUD_OCI_CR_COMPUTE_LIST_INSTANCES_RESPONSE_T;

    -- Coleção de instâncias extraída do corpo da resposta
    l_instances DBMS_CLOUD_OCI_CORE_INSTANCE_TBL;

    -- Variável auxiliar para iterar cada instância individualmente
    l_inst      DBMS_CLOUD_OCI_CORE_INSTANCE_T;
BEGIN
    -- Chama a API OCI passando o compartimento (aqui usa o OCID da tenancy como
    -- compartimento raiz) e a região desejada
    l_response := DBMS_CLOUD_OCI_CR_COMPUTE.LIST_INSTANCES(
        compartment_id  => 'ocid1.tenancy.oc1..aaaaaaaanme23ootfiaxnavkpwvrl2ssvkmqcjx7wzkcvv2jbtxhndastl2q',
        region          => 'sa-saopaulo-1',
        credential_name => 'OCI_CREDENTIAL'
    );

    DBMS_OUTPUT.PUT_LINE('Status HTTP: ' || l_response.status_code);

    l_instances := l_response.response_body;

    IF l_instances IS NULL OR l_instances.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nenhuma instância encontrada.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Total: ' || l_instances.COUNT || ' instância(s)');
        DBMS_OUTPUT.PUT_LINE('========================================');

        FOR i IN 1 .. l_instances.COUNT LOOP
            l_inst := l_instances(i);

            DBMS_OUTPUT.PUT_LINE('Nome:   ' || l_inst.display_name);
            DBMS_OUTPUT.PUT_LINE('OCID:   ' || l_inst.id);
            DBMS_OUTPUT.PUT_LINE('Shape:  ' || l_inst.shape);
            DBMS_OUTPUT.PUT_LINE('Status: ' || l_inst.lifecycle_state);
            DBMS_OUTPUT.PUT_LINE('AD:     ' || l_inst.availability_domain);
            DBMS_OUTPUT.PUT_LINE('Região: ' || l_inst.l_region);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        END LOOP;
    END IF;

EXCEPTION
    -- Captura qualquer erro inesperado da API ou do banco e exibe a mensagem
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;
/
