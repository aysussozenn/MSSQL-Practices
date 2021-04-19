SET STATISTICS IO ON

SELECT
  PT.ProductID
, MAX(Quantity) AS TotalQuantity
, MIN(TransactionId) AS MinTransactionId
FROM Production.TransactionHistory as PT INNER JOIN Production.Product as PP
ON PT.ProductID=PP.ProductID
WHERE TransactionType LIKE 'P%' 
GROUP BY PT.ProductID
ORDER BY PT.ProductID  DESC