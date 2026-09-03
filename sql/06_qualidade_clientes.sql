USE CoopData;
GO

SELECT
    COUNT(*) AS total_registros,
    COUNT(DISTINCT cliente_id) AS clientes_distintos,
    COUNT(*) - COUNT(DISTINCT cliente_id) AS registros_excedentes
FROM dbo.clientes_raw;

SELECT
    COUNT(*) AS total_registros,
    COUNT(*) - COUNT(cidade) AS cidade_ausente,
    COUNT(*) - COUNT(segmento) AS segmento_ausente
FROM dbo.clientes_raw;

SELECT
    cliente_id,
    COUNT(*) AS quantidade_registros
FROM dbo.clientes_raw
GROUP BY cliente_id
HAVING COUNT(*) > 1
ORDER BY
    quantidade_registros DESC,
    cliente_id;

SELECT
    cliente_id,
    nome,
    data_nascimento,
    genero,
    cidade,
    estado,
    data_cadastro,
    segmento,
    COUNT(*) AS quantidade_registros
FROM dbo.clientes_raw
GROUP BY
    cliente_id,
    nome,
    data_nascimento,
    genero,
    cidade,
    estado,
    data_cadastro,
    segmento
HAVING COUNT(*) >1
ORDER BY cliente_id;

SELECT
    SUM(
        CASE
            WHEN cidade IS NULL AND segmento IS NULL THEN 1
            ELSE 0
        END
    ) AS cidade_e_segmento_ausentes,

    SUM(
        CASE
            WHEN cidade IS NULL AND segmento IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS somente_cidade_ausente,

    SUM(
        CASE
            WHEN cidade IS NOT NULL AND segmento IS NULL THEN 1
            ELSE 0
        END
    ) AS somente_segmento_ausente
FROM dbo.clientes_raw;

SELECT
    estado,
    COUNT(*) AS quantidade_clientes
FROM dbo.clientes_raw
GROUP BY estado
ORDER BY estado;

SELECT
    SUM(
        CASE
            WHEN estado = 'XX'
                 AND cidade IS NULL
            THEN 1
            ELSE 0
        END
    ) AS estado_invalido_e_cidade_ausente,

    SUM(
        CASE
            WHEN estado = 'XX'
                 AND segmento IS NULL
            THEN 1
            ELSE 0
        END
    ) AS estado_invalido_e_segmento_ausente,

    SUM(
        CASE
            WHEN cidade IS NULL
                 OR segmento IS NULL
                 OR estado = 'XX'
            THEN 1
            ELSE 0
        END
    ) AS total_registros_com_problema
FROM dbo.clientes_raw;

SELECT TOP 30
    cliente_id,
    nome,
    cidade,
    estado,
    segmento
FROM dbo.clientes_raw
WHERE
    cidade IS NULL
    OR segmento IS NULL
    OR estado = 'XX'
ORDER BY cliente_id;

SELECT TOP 5
    'Cidade ausente' AS problema,
    cliente_id,
    nome,
    cidade,
    estado,
    segmento
FROM dbo.clientes_raw
WHERE cidade IS NULL

UNION ALL

SELECT TOP 5
    'Segmento ausente',
    cliente_id,
    nome,
    cidade,
    estado,
    segmento
FROM dbo.clientes_raw
WHERE segmento IS NULL

UNION ALL

SELECT TOP 5
    'Estado inválido',
    cliente_id,
    nome,
    cidade,
    estado,
    segmento
FROM dbo.clientes_raw
WHERE estado = 'XX';

SELECT
    genero,
    COUNT(*) AS quantidade_registros
FROM dbo.clientes_raw
GROUP BY genero
ORDER BY genero;

SELECT
    segmento,
    COUNT(*) AS quantidade_registros
FROM dbo.clientes_raw
GROUP BY segmento
ORDER BY segmento;

SELECT
    MIN(data_nascimento) AS menor_data_nascimento,
    MAX(data_nascimento) AS maior_data_nascimento,
    MIN(data_cadastro) AS primeiro_cadastro,
    MAX(data_cadastro) AS ultimo_cadastro
FROM dbo.clientes_raw;

SELECT
    CAST(GETDATE() AS date) AS data_atual,

    SUM(
        CASE
            WHEN data_nascimento > CAST(GETDATE() AS date)
            THEN 1
            ELSE 0
        END
    ) AS nascimento_no_futuro,

    SUM(
        CASE
            WHEN data_cadastro > CAST(GETDATE() AS date)
            THEN 1
            ELSE 0
        END
    ) AS cadastro_no_futuro,

    SUM(
        CASE
            WHEN data_nascimento > data_cadastro
            THEN 1
            ELSE 0
        END
    ) AS nascimento_apos_cadastro
FROM dbo.clientes_raw;

SELECT
    genero,
    COUNT(*) AS total_registros,

    SUM(
        CASE
            WHEN data_cadastro > CAST(GETDATE() AS date)
            THEN 1
            ELSE 0
        END
    ) AS cadastro_no_futuro,

    SUM(
        CASE
            WHEN data_nascimento > data_cadastro
            THEN 1
            ELSE 0
        END
    ) AS nascimento_apos_cadastro
FROM dbo.clientes_raw
GROUP BY genero
ORDER BY genero;

SELECT TOP 10
    cliente_id,
    nome,
    genero,
    data_nascimento,
    data_cadastro
FROM dbo.clientes_raw
WHERE data_nascimento > data_cadastro
ORDER BY cliente_id;

SELECT
    genero,
    segmento,
    COUNT(*) AS quantidade_registros
FROM dbo.clientes_raw
GROUP BY
    genero,
    segmento
ORDER BY
    genero,
    segmento;