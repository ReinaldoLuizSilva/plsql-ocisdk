-- =============================================================================
-- Listar Objetos de um Bucket — OCI Object Storage
-- =============================================================================
-- Retorna os arquivos presentes em um bucket OCI usando a credencial
-- previamente criada em setup/01_credencial.sql.
--
-- Substitua <namespace> e <bucket> pelos valores da sua tenancy.
-- O namespace pode ser consultado em: OCI Console > Object Storage > Buckets
-- =============================================================================

SELECT *
FROM DBMS_CLOUD.LIST_OBJECTS(
    credential_name => 'OCI_CREDENTIAL',
    location_uri    => 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/<namespace>/b/<bucket>/o/'
);
