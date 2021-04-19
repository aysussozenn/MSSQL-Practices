
WITH ProductCostHistory AS
(
   SELECT
   StandardCost,
   ProductID
   FROM Production.ProductCostHistory
),
Production AS
(
    SELECT
	 SafetyStockLevel,
	 ReorderPoint,
	 Color,
	 ProductID AS ID
	FROM Production.Product
),
 JoinProduction AS
(
  SELECT
  *
  FROM Production AS P INNER JOIN ProductCostHistory AS H
  ON P.ID = H.ProductID
),
FilteredProduction AS
(
   SELECT 
  *
   FROM JoinProduction
   WHERE ReorderPoint<500
),
GroupedProduct AS
(
  SELECT 
  Color,
  COUNT(*) AS ColorCount,
  SUM(SafetyStockLevel) AS TotalSafetyStockLevel,
  MAX(StandardCost)-MIN(StandardCost) AS StandartCostChange
  FROM FilteredProduction
  GROUP BY Color
)
SELECT
*
FROM GroupedProduct
WHERE ColorCount>10













