SELECT
 ProductID,
  MIN(TransactionId) AS MinTransactionId,
  MAX(Quantity) AS TotalQuantity
FROM Production.TransactionHistory
WHERE TransactionType LIKE 'P%' and (TransactionID between 104000 and 115000)
ü
