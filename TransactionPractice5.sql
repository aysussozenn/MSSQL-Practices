SET STATISTICS IO ON
SELECT
ProductID
, MAX(Quantity) AS TotalQuantity
, MIN(TransactionId) AS MinTransactionId
FROM Production.TransactionHistory
WHERE TransactionType = 'P' 
GROUP BY ProductID
ORDER BY ProductID DESC