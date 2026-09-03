USE CoopData;
GO

CREATE OR ALTER VIEW tratado.vw_agencias AS

SELECT
    CAST(agencia_id AS int) AS agencia_id,
    nome_agencia,
    cidade,
    estado,
    data_abertura,
    tipo_agencia
FROM dbo.agencias_raw;
GO

CREATE OR ALTER VIEW tratado.vw_produtos AS

SELECT
    CAST(produto_id AS int) AS produto_id,
    nome_produto,
    categoria,
    status_produto
FROM dbo.produtos_raw;
GO

SELECT COUNT(*) AS total_agencias
FROM tratado.vw_agencias;

SELECT COUNT(*) AS total_produtos
FROM tratado.vw_produtos;