IF DB_ID('CoopData') IS NULL
    CREATE DATABASE CoopData;
GO

USE CoopData;
GO

SELECT DB_NAME() AS banco_atual;