USE CoopData;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'tratado'
)
BEGIN
    EXEC('CREATE SCHEMA tratado');
END;
GO

CREATE OR ALTER VIEW tratado.vw_clientes AS

SELECT DISTINCT
    CAST(cliente_id AS int) AS cliente_id,
    nome,

    CASE
        WHEN genero IN ('F', 'M')
        THEN data_nascimento
        ELSE NULL
    END AS data_nascimento,

    CASE
        WHEN genero = 'PJ'
             AND data_nascimento <= data_cadastro
        THEN data_nascimento
        ELSE NULL
    END AS data_constituicao,

    genero,

    COALESCE(cidade, 'Não informado') AS cidade,

    CASE
        WHEN estado IN (
            'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF',
            'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA',
            'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS',
            'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
        )
        THEN estado
        ELSE 'NI'
    END AS estado,

    data_cadastro,

    CASE
        WHEN segmento IS NULL AND genero = 'PJ'
        THEN 'Pessoa Jurídica'

        WHEN segmento IS NULL
        THEN 'Não informado'

        ELSE segmento
    END AS segmento,

    CASE
        WHEN cidade IS NULL THEN 1
        ELSE 0
    END AS flag_cidade_ausente,

    CASE
        WHEN segmento IS NULL THEN 1
        ELSE 0
    END AS flag_segmento_ausente,

    CASE
        WHEN estado NOT IN (
            'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF',
            'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA',
            'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS',
            'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
        )
        THEN 1
        ELSE 0
    END AS flag_estado_invalido,

    CASE
        WHEN data_cadastro > CAST(GETDATE() AS date)
        THEN 1
        ELSE 0
    END AS flag_cadastro_futuro,

    CASE
        WHEN genero = 'PJ'
             AND data_nascimento > data_cadastro
        THEN 1
        ELSE 0
    END AS flag_data_constituicao_invalida

FROM dbo.clientes_raw;
GO

SELECT COUNT(*) AS total_clientes_tratados
FROM tratado.vw_clientes;
GO

SELECT
    SUM(flag_cidade_ausente) AS cidades_tratadas,
    SUM(flag_segmento_ausente) AS segmentos_tratados,
    SUM(flag_estado_invalido) AS estados_tratados,
    SUM(flag_cadastro_futuro) AS cadastros_futuros,
    SUM(flag_data_constituicao_invalida) AS datas_constituicao_invalidas
FROM tratado.vw_clientes;
GO