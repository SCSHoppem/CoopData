USE CoopData;
GO

SELECT
    COUNT(*) AS total_registros,
    COUNT(DISTINCT emprestimo_id) AS emprestimos_distintos,
    COUNT(*) - COUNT(DISTINCT emprestimo_id) AS registros_excedentes,

    SUM(
        CASE
            WHEN valor_contratado IS NULL THEN 1
            ELSE 0
        END
    ) AS valor_ausente,

    SUM(
        CASE
            WHEN valor_contratado <= 0 THEN 1
            ELSE 0
        END
    ) AS valor_invalido,

    MIN(valor_contratado) AS menor_valor_importado,
    MAX(valor_contratado) AS maior_valor_importado,

    MIN(valor_contratado / 100.0) AS menor_valor_corrigido,
    MAX(valor_contratado / 100.0) AS maior_valor_corrigido,

    MIN(taxa_mensal) AS menor_taxa_importada,
    MAX(taxa_mensal) AS maior_taxa_importada,

    MIN(taxa_mensal / 10000.0) AS menor_taxa_corrigida,
    MAX(taxa_mensal / 10000.0) AS maior_taxa_corrigida
FROM dbo.emprestimos_raw;

SELECT
    status_emprestimo,
    COUNT(*) AS quantidade_registros
FROM dbo.emprestimos_raw
GROUP BY status_emprestimo
ORDER BY status_emprestimo;

SELECT
    MIN(data_contratacao) AS primeira_contratacao,
    MAX(data_contratacao) AS ultima_contratacao,

    SUM(
        CASE
            WHEN data_contratacao > CAST(GETDATE() AS date)
            THEN 1
            ELSE 0
        END
    ) AS contratacoes_no_futuro,

    MIN(quantidade_parcelas) AS menor_quantidade_parcelas,
    MAX(quantidade_parcelas) AS maior_quantidade_parcelas,

    SUM(
        CASE
            WHEN quantidade_parcelas <= 0
            THEN 1
            ELSE 0
        END
    ) AS quantidade_parcelas_invalida
FROM dbo.emprestimos_raw;

SELECT
    SUM(
        CASE
            WHEN c.cliente_id IS NULL THEN 1
            ELSE 0
        END
    ) AS emprestimos_sem_cliente,

    SUM(
        CASE
            WHEN a.agencia_id IS NULL THEN 1
            ELSE 0
        END
    ) AS emprestimos_sem_agencia,

    SUM(
        CASE
            WHEN p.produto_id IS NULL THEN 1
            ELSE 0
        END
    ) AS emprestimos_sem_produto
FROM dbo.emprestimos_raw AS e

LEFT JOIN (
    SELECT DISTINCT cliente_id
    FROM dbo.clientes_raw
) AS c
    ON e.cliente_id = c.cliente_id

LEFT JOIN dbo.agencias_raw AS a
    ON e.agencia_id = a.agencia_id

LEFT JOIN dbo.produtos_raw AS p
    ON e.produto_id = p.produto_id;

    SELECT
    COUNT(*) AS emprestimos_antes_do_cadastro
FROM dbo.emprestimos_raw AS e

INNER JOIN (
    SELECT DISTINCT
        cliente_id,
        data_cadastro
    FROM dbo.clientes_raw
) AS c
    ON e.cliente_id = c.cliente_id

WHERE e.data_contratacao < c.data_cadastro;