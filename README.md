# plsql-ocisdk

Scripts PL/SQL para integração com a **OCI SDK** via `DBMS_CLOUD` e `DBMS_CLOUD_OCI` (disponíveis em Oracle Autonomous Database).

## Estrutura

```
plsql-ocisdk/
├── setup/
│   └── 01_credencial.sql       — Cria a credencial OCI (executar primeiro)
├── storage/
│   └── 01_listar_objetos.sql   — Lista objetos de um bucket OCI
└── compute/
    └── 01_listar_instancias.sql — Lista instâncias de Compute
```

## Como usar

1. Execute `setup/01_credencial.sql` substituindo os placeholders pelos seus valores OCI.
2. Execute os scripts de `storage/` ou `compute/` conforme necessário.
