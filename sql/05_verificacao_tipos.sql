SELECT
    TABLE_NAME AS tabela,
    COLUMN_NAME AS coluna,
    DATA_TYPE AS tipo_dado,
    IS_NULLABLE AS permite_nulo
FROM INFORMATION_SCHEMA.COLUMNS
WHERE
    (TABLE_NAME = 'clientes_raw'
        AND COLUMN_NAME IN ('cliente_id', 'data_nascimento'))
    OR
    (TABLE_NAME = 'transacoes_raw'
        AND COLUMN_NAME = 'valor')
    OR
    (TABLE_NAME = 'emprestimos_raw'
        AND COLUMN_NAME = 'valor_contratado')
    OR
    (TABLE_NAME = 'pagamentos_raw'
        AND COLUMN_NAME = 'data_pagamento')
ORDER BY TABLE_NAME, COLUMN_NAME;