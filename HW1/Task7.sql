USE AdventureWorks2016
GO

CREATE PROCEDURE HowSingleMen(
	@birthdates AS date,
	@birthdatepo AS date,
	@singlemen AS INT OUTPUT
)
AS
BEGIN
	SELECT @singlemen = COUNT(*)
	FROM HumanResources.Employee	
	WHERE Gender = 'M' AND MaritalStatus = 'S' AND BirthDate BETWEEN @birthdates AND @birthdatepo;

	SELECT *
	FROM HumanResources.Employee	
	WHERE Gender = 'M' AND MaritalStatus = 'S' AND BirthDate BETWEEN @birthdates AND @birthdatepo;

END