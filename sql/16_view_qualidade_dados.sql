USE CoopData;
GO

CREATE OR ALTER VIEW tratado.vw_qualidade_dados AS

SELECT
    'Clientes' AS tabela,
    'Duplicidades removidas' AS indicador,
    (
        SELECT COUNT(*) FROM dbo.clientes_raw
    ) - (
        SELECT COUNT(*) FROM tratado.vw_clientes
    ) AS quantidade

UNION ALL

SELECT
    'Clientes',
    'Cidade ausente',
    SUM(flag_cidade_ausente)
FROM tratado.vw_clientes

UNION ALL

SELECT
    'Clientes',
    'Segmento ausente',
    SUM(flag_segmento_ausente)
FROM tratado.vw_clientes

UNION ALL

SELECT
    'Clientes',
    'Estado inválido',
    SUM(flag_estado_invalido)
FROM tratado.vw_clientes

UNION ALL

SELECT
    'Clientes',
    'Cadastro futuro',
    SUM(flag_cadastro_futuro)
FROM tratado.vw_clientes

UNION ALL

SELECT
    'Clientes',
    'Data de constituição inválida',
    SUM(flag_data_constituicao_invalida)
FROM tratado.vw_clientes

UNION ALL

SELECT
    'Transações',
    'Registros com ID conflitante removidos',
    (
        SELECT COUNT(*) FROM dbo.transacoes_raw
    ) - (
        SELECT COUNT(*) FROM tratado.vw_transacoes
    )

UNION ALL

SELECT
    'Transações',
    'Status ausente',
    SUM(flag_status_ausente)
FROM tratado.vw_transacoes

UNION ALL

SELECT
    'Transações',
    'Transação futura',
    SUM(flag_transacao_futura)
FROM tratado.vw_transacoes

UNION ALL

SELECT
    'Transações',
    'Transação anterior ao cadastro',
    SUM(flag_antes_cadastro)
FROM tratado.vw_transacoes

UNION ALL

SELECT
    'Empréstimos',
    'Contratação futura',
    SUM(flag_contratacao_futura)
FROM tratado.vw_emprestimos

UNION ALL

SELECT
    'Empréstimos',
    'Contratação anterior ao cadastro',
    SUM(flag_antes_cadastro)
FROM tratado.vw_emprestimos

UNION ALL

SELECT
    'Pagamentos',
    'Parcela acima do contratado',
    SUM(flag_parcela_acima_contratado)
FROM tratado.vw_pagamentos

UNION ALL

SELECT
    'Pagamentos',
    'Vencimento anterior ao contrato',
    SUM(flag_vencimento_antes_contrato)
FROM tratado.vw_pagamentos

UNION ALL

SELECT
    'Pagamentos',
    'Pagamento anterior ao contrato',
    SUM(flag_pagamento_antes_contrato)
FROM tratado.vw_pagamentos;
GO

SELECT *
FROM tratado.vw_qualidade_dados
ORDER BY
    tabela,
    indicador;