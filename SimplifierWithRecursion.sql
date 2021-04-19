WITH TESTDATA (TestID, Numerator, Denumerator) AS 
(
	SELECT
		*
	FROM (
		VALUES
		(1, 28, 49),			-->  4/7
		(2, -28, -49),			-->  4/7
		(3, 28, -49),			-->  -4/7
		(4, -28, 49),			-->  -4/7

		(5, 22, 6),				-->  11/3
		(6, -22, -6),			-->  11/3
		(7, 22, -6),			-->  -11/3
		(8, -22, 6),			-->  -11/3
		
		(9, 28, 14),			-->  2
		(10, -28, -14),			-->  2
		(11, 28, -14),			-->  -2
		(12, -28, 14),			-->  -2

		(13, 7919, 2687),		-->  7919/2687
		(14, -7, -2),			-->  7/2
		(15, 11, -17),			-->  -11/17
		(16, -19, 9),			-->  -19/9

		(17, 15, -3),			-->  -5
		(18, -20, 4),			-->  -5
		(19, -10, -2),			-->  5
		(20, 5, 1),				-->  5

		(21, 1, 1),				-->  1
		(22, -1, -1),			-->  1
		(23, 1, -1),			-->  -1
		(24, -1, 1),			-->  -1
		(25, -7, -7),			-->  1
		(26, 7, -7),			-->  -1

		(27, 0, 2),				-->  0
		(28, 0, -2),			-->  0
		(29, 0, 1),				-->  0
		(30, 0, -1),			-->  0

		(31, 2, 0),				-->  +Infinity
		(32, -100, 0),			-->  -Infinity
		(33, 0, 0),				-->  NaN

		(34, 10, NULL),			-->  NULL
		(35, -5, NULL),			-->  NULL
		(36, 0, NULL),			-->  NULL
		(37, NULL, 11),			-->  NULL
		(38, NULL, -8),			-->  NULL
		(39, NULL, 0),			-->  NULL
		(40, NULL, NULL)
		--(41, 78, 84)          --> 13/14
		--(42, 39, 65)          --> 3/5
		--(43, 27, 243)          --> 1/9
		--(44, -39, -65)          --> 3/5
	) 
	TESTDATA (TestID, Numerator, Denumerator)
),
SET1 (TestID, IndexNumber, Numerator, Denumerator) AS
(
	  SELECT
	  TestID, 
	  1 AS IndexNumber ,
	  Numerator,
	  Denumerator
	
	  FROM TESTDATA

	  UNION ALL 
	  SELECT
	  TestID , 
	  IndexNumber + 1 AS IndexNumber,
	  Numerator,
	  Denumerator
	  FROM SET1
	  WHERE (Numerator)>IndexNumber OR ((Numerator*-1))>IndexNumber
) ,
SET2(TestID,Numerator, Denumerator) AS
(
	SELECT 
	TestID,
	(CASE WHEN (Numerator%(IndexNumber+1)=0) AND (Denumerator%(IndexNumber+1)=0) THEN CAST(Numerator/(IndexNumber+1)as int) ELSE Numerator END)AS Numerator,
	(CASE WHEN (Numerator%(IndexNumber+1)=0) AND (Denumerator%(IndexNumber+1)=0) THEN CAST(Denumerator/(IndexNumber+1)as int) ELSE Denumerator END)AS Denumerator
	FROM SET1
),

RESULT AS 
(
	SELECT
	TestID AS ID,
	(CASE WHEN MIN(Numerator)>0 THEN MIN(Numerator) ELSE MAX(Numerator) END) AS Numerator1,
	(CASE WHEN MIN(Denumerator)>0 THEN MIN(Denumerator) ELSE MAX(Denumerator) END) AS Denumerator1
	FROM SET2
	GROUP BY TestID
	
)
SELECT
	TestID, 
Numerator,
Denumerator,

	(CASE WHEN ((Denumerator1=0)AND(Numerator1<0)) THEN '-Infinity'
	      WHEN ((Denumerator1=0)AND(Numerator1>0)) THEN '+Infinity'
		  WHEN ((Denumerator1=0)AND(Numerator1=0)) THEN 'NaN'
		  WHEN ((Denumerator1 IS NULL )OR(Numerator1 IS NULL)) THEN 'Undefined'
		  WHEN ((Denumerator1!=0)AND(Numerator1%Denumerator1=0))THEN CAST((Numerator1/Denumerator1)as varchar(50))
		  WHEN((Denumerator1!=0) AND ((CAST((Numerator1/Denumerator1)as decimal)>0)OR(CAST((Denumerator1/Numerator1)as decimal)>0)) AND (Numerator1>0 AND Denumerator1>0)) THEN CAST(Numerator1 as varchar(50))+'/'+CAST(Denumerator1 as varchar(50))
		  WHEN((Denumerator1!=0) AND ((CAST((Numerator1/Denumerator1)as decimal)>0)OR(CAST((Denumerator1/Numerator1)as decimal)>0)) AND (Numerator1<0 AND Denumerator1<0)) THEN CAST((Numerator1*-1) as varchar(50))+'/'+CAST((Denumerator1*-1) as varchar(50))
		  WHEN((Denumerator1!=0) AND ((CAST((Numerator1/Denumerator1)as decimal)<0)OR(CAST((Denumerator1/Numerator1)as decimal)<0)) AND (Denumerator1<0)) THEN '-'+CAST((Numerator1) as varchar(50))+'/'+CAST((Denumerator1*-1) as varchar(50))
		  WHEN((Denumerator1!=0) AND ((CAST((Numerator1/Denumerator1)as decimal)<0)OR(CAST((Denumerator1/Numerator1)as decimal)<0)) AND (Numerator1<0)) THEN '-'+CAST(((Numerator1*-1)) as varchar(50))+'/'+CAST((Denumerator1) as varchar(50))
		  END)as Simplified
FROM SET1 AS S1 INNER JOIN RESULT AS R
ON S1.TestID=R.ID
GROUP BY TestID,Denumerator,Numerator,Denumerator1,Numerator1
ORDER BY TestID
OPTION (MAXRECURSION 30000)
