USE AdventureWorks2016
GO

SELECT 
	PPD.LastName+' '+LEFT(PPD.FirstName,1)+'.'+ISNULL(LEFT(PPD.MiddleName,1)+'.','') AS NameDirector,
	HE1.HireDate AS DirectorHireDate,
	HE1.BirthDate AS DirectorBirthDate,
	PPE.LastName+' '+LEFT(PPE.FirstName,1)+'.'+ISNULL(LEFT(PPE.MiddleName,1)+'.','') AS NameEmpolyee,
	HE2.HireDate AS EmpolyeeHireDate,
	HE2.BirthDate AS EmpoleeBirthDate 
FROM HumanResources.Employee HE1
	INNER JOIN HumanResources.Employee HE2
		ON ISNULL(HE1.OrganizationNode,hierarchyid::GetRoot()) = HE2.OrganizationNode.GetAncestor(1)
			AND HE1.BirthDate>HE2.BirthDate AND HE1.HireDate>HE2.HireDate 
	LEFT JOIN Person.Person AS PPD
		ON HE1.BusinessEntityID = PPD.BusinessEntityID
	LEFT JOIN Person.Person as PPE
		ON HE2.BusinessEntityID = PPE.BusinessEntityID
ORDER BY ISNULL(HE1.OrganizationLevel,0), NameEmpolyee






