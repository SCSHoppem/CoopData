USE CoopData;
GO

SELECT
    COUNT(*) AS total_registros,
    COUNT(DISTINCT pagamento_id) AS pagamentos_distintos,
    COUNT(*) - COUNT(DISTINCT pagamento_id) AS registros_excedentes,

    SUM(
        CASE
            WHEN valor_parcela IS NULL THEN 1
            ELSE 0
        END
    ) AS valor_ausente,

    SUM(
        CASE
            WHEN valor_parcela <= 0 THEN 1
            ELSE 0
        END
    ) AS valor_invalido,

    SUM(
        CASE
            WHEN data_pagamento IS NULL THEN 1
            ELSE 0
        END
    ) AS data_pagamento_ausente,

    MIN(valor_parcela) AS menor_valor_importado,
    MAX(valor_parcela) AS maior_valor_importado,

    MIN(valor_parcela / 100.0) AS menor_valor_corrigido,
    MAX(valor_parcela / 100.0) AS maior_valor_corrigido
FROM dbo.pagamentos_raw;

SELECT
    status_pagamento,
    COUNT(*) AS quantidade_registros
FROM dbo.pagamentos_raw
GROUP BY status_pagamento
ORDER BY status_pagamento;

SELECT
    SUM(
        CASE
            WHEN status_pagamento = 'Pago'
                 AND data_pagamento IS NULL
            THEN 1
            ELSE 0
        END
    ) AS pago_sem_data,

    SUM(
        CASE
            WHEN status_pagamento = 'Pendente'
                 AND data_pagamento IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS pendente_com_data,

    SUM(
        CASE
            WHEN status_pagamento = 'Em atraso'
                 AND data_pagamento IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS em_atraso_com_data
FROM dbo.pagamentos_raw;

SELECT
    SUM(
        CASE
            WHEN data_pagamento > data_vencimento
            THEN 1
            ELSE 0
        END
    ) AS pagamentos_realizados_apos_vencimento,

    SUM(
        CASE
            WHEN status_pagamento = 'Em atraso'
                 AND data_pagamento > data_vencimento
            THEN 1
            ELSE 0
        END
    ) AS em_atraso_confirmado_pelas_datas,

    SUM(
        CASE
            WHEN status_pagamento = 'Pago'
                 AND data_pagamento > data_vencimento
            THEN 1
            ELSE 0
        END
    ) AS pago_mas_realizado_em_atraso,

    SUM(
        CASE
            WHEN status_pagamento = 'Em atraso'
                 AND data_pagamento <= data_vencimento
            THEN 1
            ELSE 0
        END
    ) AS marcado_atraso_mas_pago_no_prazo
FROM dbo.pagamentos_raw;

SELECT
    SUM(
        CASE
            WHEN status_pagamento = 'Pendente'
                 AND data_vencimento < CAST(GETDATE() AS date)
            THEN 1
            ELSE 0
        END
    ) AS pendentes_ja_vencidos,

    SUM(
        CASE
            WHEN status_pagamento = 'Pendente'
                 AND data_vencimento >= CAST(GETDATE() AS date)
            THEN 1
            ELSE 0
        END
    ) AS pendentes_a_vencer
FROM dbo.pagamentos_raw;

SELECT
    SUM(
        CASE
            WHEN e.emprestimo_id IS NULL THEN 1
            ELSE 0
        END
    ) AS pagamentos_sem_emprestimo,

    SUM(
        CASE
            WHEN c.cliente_id IS NULL THEN 1
            ELSE 0
        END
    ) AS pagamentos_sem_cliente,

    SUM(
        CASE
            WHEN e.emprestimo_id IS NOT NULL
                 AND pg.cliente_id <> e.cliente_id
            THEN 1
            ELSE 0
        END
    ) AS cliente_diferente_do_emprestimo,

    SUM(
        CASE
            WHEN e.emprestimo_id IS NOT NULL
                 AND pg.numero_parcela > e.quantidade_parcelas
            THEN 1
            ELSE 0
        END
    ) AS parcela_acima_do_contratado
FROM dbo.pagamentos_raw AS pg

LEFT JOIN dbo.emprestimos_raw AS e
    ON pg.emprestimo_id = e.emprestimo_id

LEFT JOIN (
    SELECT DISTINCT cliente_id
    FROM dbo.clientes_raw
) AS c
    ON pg.cliente_id = c.cliente_id;

    SELECT
    SUM(
        CASE
            WHEN pg.data_vencimento < e.data_contratacao
            THEN 1
            ELSE 0
        END
    ) AS vencimento_antes_da_contratacao,

    SUM(
        CASE
            WHEN pg.data_pagamento < e.data_contratacao
            THEN 1
            ELSE 0
        END
    ) AS pagamento_antes_da_contratacao
FROM dbo.pagamentos_raw AS pg

INNER JOIN dbo.emprestimos_raw AS e
    ON pg.emprestimo_id = e.emprestimo_id;