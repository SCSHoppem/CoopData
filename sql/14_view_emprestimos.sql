USE CoopData;
GO

CREATE OR ALTER VIEW tratado.vw_emprestimos AS

SELECT
    CAST(e.emprestimo_id AS int) AS emprestimo_id,
    CAST(e.cliente_id AS int) AS cliente_id,
    CAST(e.agencia_id AS int) AS agencia_id,
    CAST(e.produto_id AS int) AS produto_id,

    e.data_contratacao,

    CAST(
        e.valor_contratado / 100.0
        AS decimal(18,2)
    ) AS valor_contratado,

    e.quantidade_parcelas,

    CAST(
        e.taxa_mensal / 10000.0
        AS decimal(10,4)
    ) AS taxa_mensal,

    e.status_emprestimo,

    CASE
        WHEN e.data_contratacao > CAST(GETDATE() AS date)
        THEN 1
        ELSE 0
    END AS flag_contratacao_futura,

    CASE
        WHEN e.data_contratacao < c.data_cadastro
        THEN 1
        ELSE 0
    END AS flag_antes_cadastro,

    CASE
        WHEN e.data_contratacao <= CAST(GETDATE() AS date)
             AND e.data_contratacao >= c.data_cadastro
        THEN 1
        ELSE 0
    END AS flag_apto_indicadores

FROM dbo.emprestimos_raw AS e

INNER JOIN tratado.vw_clientes AS c
    ON e.cliente_id = c.cliente_id;
GO

SELECT
    COUNT(*) AS emprestimos_tratados,
    COUNT(DISTINCT emprestimo_id) AS ids_distintos,
    SUM(flag_contratacao_futura) AS contratacoes_futuras,
    SUM(flag_antes_cadastro) AS antes_do_cadastro,
    SUM(flag_apto_indicadores) AS aptos_indicadores,
    MIN(valor_contratado) AS menor_valor,
    MAX(valor_contratado) AS maior_valor,
    MIN(taxa_mensal) AS menor_taxa,
    MAX(taxa_mensal) AS maior_taxa
FROM tratado.vw_emprestimos;