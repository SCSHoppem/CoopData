SELECT
    COUNT(*) AS total_registros,
    COUNT(DISTINCT transacao_id) AS transacoes_distintas,
    COUNT(*) - COUNT(DISTINCT transacao_id) AS registros_excedentes,

    SUM(
        CASE
            WHEN status_transacao IS NULL THEN 1
            ELSE 0
        END
    ) AS status_ausente,

    SUM(
        CASE
            WHEN valor IS NULL THEN 1
            ELSE 0
        END
    ) AS valor_ausente,

    SUM(
        CASE
            WHEN valor < 0 THEN 1
            ELSE 0
        END
    ) AS valor_negativo,

    MIN(valor) AS menor_valor,
    MAX(valor) AS maior_valor
FROM dbo.transacoes_raw;

SELECT TOP 10
    transacao_id,
    valor AS valor_importado,
    valor / 100.0 AS valor_corrigido
FROM dbo.transacoes_raw
ORDER BY transacao_id;

SELECT
    transacao_id,
    COUNT(*) AS quantidade_registros
FROM dbo.transacoes_raw
GROUP BY transacao_id
HAVING COUNT(*) > 1
ORDER BY
    quantidade_registros DESC,
    transacao_id;

    SELECT
    transacao_id,
    cliente_id,
    agencia_id,
    produto_id,
    data_transacao,
    tipo_transacao,
    canal,
    valor,
    status_transacao,
    COUNT(*) AS quantidade_registros
FROM dbo.transacoes_raw
GROUP BY
    transacao_id,
    cliente_id,
    agencia_id,
    produto_id,
    data_transacao,
    tipo_transacao,
    canal,
    valor,
    status_transacao
HAVING COUNT(*) > 1
ORDER BY transacao_id;

SELECT
    transacao_id,
    cliente_id,
    agencia_id,
    produto_id,
    data_transacao,
    tipo_transacao,
    canal,
    valor / 100.0 AS valor_corrigido,
    status_transacao
FROM dbo.transacoes_raw
WHERE transacao_id IN (
    SELECT transacao_id
    FROM dbo.transacoes_raw
    GROUP BY transacao_id
    HAVING COUNT(*) > 1
)
ORDER BY
    transacao_id,
    data_transacao;

    SELECT
    status_transacao,
    COUNT(*) AS quantidade_registros
FROM dbo.transacoes_raw
GROUP BY status_transacao
ORDER BY status_transacao;

SELECT
    COUNT(*) AS status_ausente_em_id_conflitante
FROM dbo.transacoes_raw
WHERE
    status_transacao IS NULL
    AND transacao_id IN (
        SELECT transacao_id
        FROM dbo.transacoes_raw
        GROUP BY transacao_id
        HAVING COUNT(*) > 1
    );

    SELECT
    SUM(
        CASE
            WHEN c.cliente_id IS NULL THEN 1
            ELSE 0
        END
    ) AS transacoes_sem_cliente,

    SUM(
        CASE
            WHEN a.agencia_id IS NULL THEN 1
            ELSE 0
        END
    ) AS transacoes_sem_agencia,

    SUM(
        CASE
            WHEN p.produto_id IS NULL THEN 1
            ELSE 0
        END
    ) AS transacoes_sem_produto
FROM dbo.transacoes_raw AS t

LEFT JOIN (
    SELECT DISTINCT cliente_id
    FROM dbo.clientes_raw
) AS c
    ON t.cliente_id = c.cliente_id

LEFT JOIN dbo.agencias_raw AS a
    ON t.agencia_id = a.agencia_id

LEFT JOIN dbo.produtos_raw AS p
    ON t.produto_id = p.produto_id;

    SELECT
    tipo_transacao,
    COUNT(*) AS quantidade_registros
FROM dbo.transacoes_raw
GROUP BY tipo_transacao
ORDER BY tipo_transacao;

SELECT
    canal,
    COUNT(*) AS quantidade_registros
FROM dbo.transacoes_raw
GROUP BY canal
ORDER BY canal;

SELECT
    MIN(data_transacao) AS primeira_transacao,
    MAX(data_transacao) AS ultima_transacao,

    SUM(
        CASE
            WHEN data_transacao > CAST(GETDATE() AS date)
            THEN 1
            ELSE 0
        END
    ) AS transacoes_no_futuro
FROM dbo.transacoes_raw;

SELECT
    COUNT(*) AS transacoes_antes_do_cadastro
FROM dbo.transacoes_raw AS t

INNER JOIN (
    SELECT DISTINCT
        cliente_id,
        data_cadastro
    FROM dbo.clientes_raw
) AS c
    ON t.cliente_id = c.cliente_id

WHERE t.data_transacao < c.data_cadastro;