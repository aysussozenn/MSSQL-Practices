WITH CitedPapers AS
(
	SELECT 
		 ROW_NUMBER() OVER (PARTITION BY AcademicianIdentityNumber ORDER BY CitationCount DESC) as RowNumber,*
	FROM Papers INNER JOIN Academician
	ON AcademicianIdentityNumber=IdentityNumber
	WHERE  CitationCount IS NOT NULL
),
HirschIndex AS
(
	SELECT
	FirstName AS FName,
	COUNT(RowNumber) AS Hindex
	FROM CitedPapers
	WHERE RowNumber<=CitationCount 
	GROUP BY AcademicianIdentityNumber,FirstName
),
 I10Index AS
(
	SELECT
	AcademicianIdentityNumber AS id,
   COUNT(CitationCount) AS i10

	FROM Papers
	WHERE  CitationCount>=10
	GROUP BY AcademicianIdentityNumber

),
AcademicianSummary AS
(
	SELECT
		CONCAT(FirstName,' ',LastSurname) AS AcademicianName, 
		Hindex AS HIndex,
		(CASE WHEN i10 IS NULL then  '0'
		      WHEN i10 IS NOT NULL then i10
			  END) AS I10Index,	  
		SUM(CitationCount) AS TotalCitation,
		MAX(CitationCount) AS MaxCitation,
		COUNT(PaperId)- COUNT(CitationCount) AS PaperWithNoCitation,
		COUNT (PaperId) AS PublicationCount,
		CAST(SUM(CitationCount)/CAST(COUNT(PaperId) as decimal)as decimal(5,2) ) AS CitationPerPaper,
		MIN(PublicationYear) AS FirstPublicationYear,
		MAX(PublicationYear) LastPublicationYear,
		COUNT(DISTINCT PublicationYear)AS PublishedYearCount,
		COUNT(ImpactFactor) AS SCIPapCount,
		MIN(ImpactFactor) AS MinImpactFactor,
		MAX(ImpactFactor) AS MaxImpactFactor
		
	  FROM I10Index FULL OUTER JOIN Papers
	  ON id=AcademicianIdentityNumber
	          INNER JOIN Academician
			  ON IdentityNumber=AcademicianIdentityNumber
			  INNER JOIN HirschIndex
			  ON FName=FirstName
	 GROUP BY AcademicianIdentityNumber,i10,Hindex,FirstName,LastSurname
	
)
SELECT
	*
FROM AcademicianSummary
ORDER BY HIndex DESC