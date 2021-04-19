WITH Emp AS
(
	SELECT
		PersonType
		, Title
		, FirstName
		, MiddleName
		, LastName
		, JobTitle
		, BirthDate
		, MaritalStatus
		, Gender
		, HireDate
	FROM HumanResources.Employee AS E INNER JOIN Person.Person AS P
	ON E.BusinessEntityID = P.BusinessEntityID
)
SELECT 
    PersonType,
	Title,
	FirstName +' '+ MiddleName +' '+ LastName AS FullName,
	JobTitle,
	(CASE WHEN MaritalStatus='S' THEN 'Single'
	      WHEN MaritalStatus='M' THEN 'Married'
		  ELSE NULL
		  END)
	 
		   +' '+
(CASE WHEN Gender ='M' THEN 'Male'
	       WHEN Gender='F' THEN 'Female'
		   ELSE NULL
		   END) AS SocialStatus
	,
	CAST(ROUND(DATEDIFF(DAY, BirthDate, CURRENT_TIMESTAMP) / 365.0,2) AS INTEGER) AS Age,
	CAST(MONTH(HireDate) AS varchar(50))+'/'+CAST(YEAR(HireDate)AS varchar(50)) AS HireMonthYear
FROM Emp
WHERE Title ='Ms.' OR  Title = 'Mr.'
