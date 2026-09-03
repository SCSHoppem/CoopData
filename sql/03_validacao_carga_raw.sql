USE CoopData;
GO

SELECT 'agencias_raw' AS tabela, COUNT(*) AS total_registros
FROM dbo.agencias_raw

UNION ALL

SELECT 'clientes_raw', COUNT(*)
FROM dbo.clientes_raw

UNION ALL

SELECT 'produtos_raw', COUNT(*)
FROM dbo.produtos_raw

UNION ALL

SELECT 'transacoes_raw', COUNT(*)
FROM dbo.transacoes_raw

UNION ALL

SELECT 'emprestimos_raw', COUNT(*)
FROM dbo.emprestimos_raw

UNION ALL

SELECT 'pagamentos_raw', COUNT(*)
FROM dbo.pagamentos_raw;