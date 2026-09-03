USE CoopData;
GO

SELECT
    COUNT(*) AS total_agencias,
    COUNT(DISTINCT agencia_id) AS agencias_distintas,
    COUNT(*) - COUNT(DISTINCT agencia_id) AS registros_excedentes,

    SUM(
        CASE
            WHEN nome_agencia IS NULL
                 OR cidade IS NULL
                 OR estado IS NULL
            THEN 1
            ELSE 0
        END
    ) AS campos_principais_ausentes,

    SUM(
        CASE
            WHEN data_abertura > CAST(GETDATE() AS date)
            THEN 1
            ELSE 0
        END
    ) AS abertura_no_futuro
FROM dbo.agencias_raw;

SELECT
    tipo_agencia,
    COUNT(*) AS quantidade
FROM dbo.agencias_raw
GROUP BY tipo_agencia
ORDER BY tipo_agencia;

SELECT
    COUNT(*) AS total_produtos,
    COUNT(DISTINCT produto_id) AS produtos_distintos,
    COUNT(*) - COUNT(DISTINCT produto_id) AS registros_excedentes,

    SUM(
        CASE
            WHEN nome_produto IS NULL
                 OR categoria IS NULL
                 OR status_produto IS NULL
            THEN 1
            ELSE 0
        END
    ) AS campos_principais_ausentes
FROM dbo.produtos_raw;

SELECT
    categoria,
    status_produto,
    COUNT(*) AS quantidade
FROM dbo.produtos_raw
GROUP BY
    categoria,
    status_produto
ORDER BY categoria;