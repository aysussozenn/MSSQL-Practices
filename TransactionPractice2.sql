SET STATISTICS IO ON
SELECT
ProductID,
(SELECT 
 MAX(Quantity)
FROM Production.TransactionHistory
WHERE TransactionType LIKE 'P%'
)AS TotalQuantity
,  
 MIN(TransactionId) AS MinTransactionId
FROM Production.TransactionHistory
WHERE TransactionType = 'P'
GROUP BY ProductID
ORDER BY ProductID DESC