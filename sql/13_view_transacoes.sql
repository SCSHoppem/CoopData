USE CoopData;
GO

CREATE OR ALTER VIEW tratado.vw_transacoes AS

WITH ids_conflitantes AS (
    SELECT
        transacao_id
    FROM dbo.transacoes_raw
    GROUP BY transacao_id
    HAVING COUNT(*) > 1
)

SELECT
    CAST(t.transacao_id AS int) AS transacao_id,
    CAST(t.cliente_id AS int) AS cliente_id,
    CAST(t.agencia_id AS int) AS agencia_id,
    CAST(t.produto_id AS int) AS produto_id,

    t.data_transacao,
    t.tipo_transacao,
    t.canal,

    CAST(t.valor / 100.0 AS decimal(18,2)) AS valor,

    COALESCE(
        t.status_transacao,
        'Não informado'
    ) AS status_transacao,

    CASE
        WHEN t.status_transacao IS NULL THEN 1
        ELSE 0
    END AS flag_status_ausente,

    CASE
        WHEN t.data_transacao > CAST(GETDATE() AS date)
        THEN 1
        ELSE 0
    END AS flag_transacao_futura,

    CASE
        WHEN t.data_transacao < c.data_cadastro
        THEN 1
        ELSE 0
    END AS flag_antes_cadastro,

    CASE
        WHEN t.data_transacao <= CAST(GETDATE() AS date)
             AND t.data_transacao >= c.data_cadastro
        THEN 1
        ELSE 0
    END AS flag_apta_indicadores

FROM dbo.transacoes_raw AS t

INNER JOIN tratado.vw_clientes AS c
    ON t.cliente_id = c.cliente_id

LEFT JOIN ids_conflitantes AS ic
    ON t.transacao_id = ic.transacao_id

WHERE ic.transacao_id IS NULL;
GO

SELECT
    COUNT(*) AS transacoes_tratadas,
    COUNT(DISTINCT transacao_id) AS ids_distintos,
    SUM(flag_status_ausente) AS status_tratados,
    SUM(flag_transacao_futura) AS transacoes_futuras,
    SUM(flag_antes_cadastro) AS antes_do_cadastro,
    SUM(flag_apta_indicadores) AS aptas_indicadores,
    MIN(valor) AS menor_valor,
    MAX(valor) AS maior_valor
FROM tratado.vw_transacoes;