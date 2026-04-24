-- Este arquivo foi reorganizado. Os scripts foram movidos para:
--   setup/01_credencial.sql       — criação de credencial
--   storage/01_listar_objetos.sql — listagem de bucket
--   compute/01_listar_instancias.sql — listagem de instâncias Compute

-- Criar credencial com chave API OCI
-- Chave privada sem o '-----BEGIN PRIVATE KEY----- -----END PRIVATE KEY-----'
BEGIN
    DBMS_CLOUD.CREATE_CREDENTIAL(
        credential_name => 'OCI_CREDENTIAL',
        user_ocid       => 'ocid1.user.oc1..xxxxx',
        tenancy_ocid    => 'ocid1.tenancy.oc1..xxxxx',
        private_key     => '<conteúdo da chave privada PEM>',
        fingerprint     => 'aa:bb:cc:...'
    );
END;
/

-- Exemplo: listar objetos de um bucket OCI / vizualizar a region da tenancy
SELECT * FROM DBMS_CLOUD.LIST_OBJECTS(
    credential_name => 'OCI_CREDENTIAL',
    location_uri    => 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/<namespace>/b/<bucket>/o/'
);

-- 
SET SERVEROUTPUT ON;
DECLARE
  l_response  DBMS_CLOUD_OCI_CR_COMPUTE_LIST_INSTANCES_RESPONSE_T;
  l_instances DBMS_CLOUD_OCI_CORE_INSTANCE_TBL;
  l_inst      DBMS_CLOUD_OCI_CORE_INSTANCE_T;
BEGIN
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
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;
/