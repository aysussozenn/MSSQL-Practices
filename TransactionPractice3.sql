SET STATISTICS IO ON
GO 
WITH SET1 AS
(
  SELECT
  ProductID as pid
  FROM Production.Product
  

),

SET2 AS(
SELECT 
ProductID,
 TransactionType,
 Quantity 
,TransactionId 
FROM Production.TransactionHistory
WHERE ProductID<953 and TransactionType LIKE 'P%'

)


 SELECT  
ProductID,
MAX(Quantity) as TotalQuantity,
MIN (TransactionId) as MinTransactionID
FROM SET1 as S1 INNER JOIN SET2 as S2
ON S1.pid=S2.ProductID
WHERE TransactionType = 'P' and ( TransactionID between 104000 and 115000) and Quantity<1251 and ProductID<953
GROUP BY ProductID
ORDER BY ProductID DESC




