USE CoopData;
GO

CREATE OR ALTER VIEW tratado.vw_pagamentos AS

SELECT
    CAST(pg.pagamento_id AS int) AS pagamento_id,
    CAST(pg.emprestimo_id AS int) AS emprestimo_id,
    CAST(pg.cliente_id AS int) AS cliente_id,

    pg.data_vencimento,
    pg.data_pagamento,
    pg.numero_parcela,

    CAST(
        pg.valor_parcela / 100.0
        AS decimal(18,2)
    ) AS valor_parcela,

    pg.status_pagamento AS status_origem,

    CASE
        WHEN pg.data_pagamento IS NULL
             AND pg.data_vencimento < CAST(GETDATE() AS date)
        THEN 'Em atraso'

        WHEN pg.data_pagamento IS NULL
        THEN 'Pendente'

        WHEN pg.data_pagamento > pg.data_vencimento
        THEN 'Pago em atraso'

        ELSE 'Pago no prazo'
    END AS status_pagamento,

    CASE
        WHEN pg.numero_parcela > e.quantidade_parcelas
        THEN 1
        ELSE 0
    END AS flag_parcela_acima_contratado,

    CASE
        WHEN pg.data_vencimento < e.data_contratacao
        THEN 1
        ELSE 0
    END AS flag_vencimento_antes_contrato,

    CASE
        WHEN pg.data_pagamento < e.data_contratacao
        THEN 1
        ELSE 0
    END AS flag_pagamento_antes_contrato,

    CASE
        WHEN e.flag_apto_indicadores = 1
             AND pg.numero_parcela <= e.quantidade_parcelas
             AND pg.data_vencimento >= e.data_contratacao
             AND (
                 pg.data_pagamento IS NULL
                 OR pg.data_pagamento >= e.data_contratacao
             )
        THEN 1
        ELSE 0
    END AS flag_apto_indicadores

FROM dbo.pagamentos_raw AS pg

INNER JOIN tratado.vw_emprestimos AS e
    ON pg.emprestimo_id = e.emprestimo_id;
GO

SELECT
    COUNT(*) AS pagamentos_tratados,
    COUNT(DISTINCT pagamento_id) AS ids_distintos,

    SUM(flag_parcela_acima_contratado)
        AS parcelas_acima_contratado,

    SUM(flag_vencimento_antes_contrato)
        AS vencimentos_antes_contrato,

    SUM(flag_pagamento_antes_contrato)
        AS pagamentos_antes_contrato,

    SUM(flag_apto_indicadores)
        AS aptos_indicadores,

    MIN(valor_parcela) AS menor_valor,
    MAX(valor_parcela) AS maior_valor
FROM tratado.vw_pagamentos;

SELECT
    status_pagamento,
    COUNT(*) AS quantidade
FROM tratado.vw_pagamentos
GROUP BY status_pagamento
ORDER BY status_pagamento;