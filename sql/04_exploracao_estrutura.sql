USE CoopData;
GO

SELECT
    TABLE_NAME AS tabela,
    COLUMN_NAME AS coluna,
    DATA_TYPE AS tipo_dado,
    CHARACTER_MAXIMUM_LENGTH AS tamanho_maximo,
    IS_NULLABLE AS permite_nulo
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN (
    'clientes_raw',
    'agencias_raw',
    'produtos_raw',
    'transacoes_raw',
    'emprestimos_raw',
    'pagamentos_raw'
)
ORDER BY
    TABLE_NAME,
    ORDINAL_POSITION;