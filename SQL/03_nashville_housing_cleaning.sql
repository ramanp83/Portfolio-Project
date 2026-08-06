/*

Cleaning Data in SQL Queries

*/

select * from PortfolioProject.dbo.Nashville_Housing

--------------------------------------------------------------------------------------------------------------------------

/* Standardize Date Format */

select SaleDate , convert(date,SaleDate)
from PortfolioProject.dbo.Nashville_Housing

-- remove time from Salesdate

update PortfolioProject.dbo.Nashville_Housing
set SaleDate = convert(date,SaleDate); -- not working


alter table PortfolioProject.dbo.Nashville_Housing
add SalesDatesConverted date; -- new column create 

update PortfolioProject.dbo.Nashville_Housing
set SalesDatesConverted = convert(date,SaleDate); -- new column create -> add alter sales date in it
 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select PropertyAddress
from PortfolioProject.dbo.Nashville_Housing

select PropertyAddress
from PortfolioProject.dbo.Nashville_Housing
where PropertyAddress is null

select ParcelID , PropertyAddress
from PortfolioProject.dbo.Nashville_Housing
--order by ParcelID
where PropertyAddress is null

select a.ParcelID , a.PropertyAddress, b.ParcelID,b.PropertyAddress
from PortfolioProject.dbo.Nashville_Housing a 
join PortfolioProject.dbo.Nashville_Housing b 
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

/* ISNULL(check_expression, replacement_value) */

select a.ParcelID , a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.Nashville_Housing a 
join PortfolioProject.dbo.Nashville_Housing b 
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- change in main table using update

update a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.Nashville_Housing a 
join PortfolioProject.dbo.Nashville_Housing b 
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- for cross check run this query
/*
select a.ParcelID , a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.Nashville_Housing a 
join PortfolioProject.dbo.Nashville_Housing b 
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
*/
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

	-- A delimiter is a specific character used to separate text strings into distinct columns

select *
from PortfolioProject.dbo.Nashville_Housing

select 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as PropertysplitAddress,
	SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as PropertsplitCity
from PortfolioProject.dbo.Nashville_Housing

alter table PortfolioProject.dbo.Nashville_Housing
add PropertySplitAddress varchar(255)

update PortfolioProject.dbo.Nashville_Housing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

alter table PortfolioProject.dbo.Nashville_Housing
add PropertSplitCity varchar(255)

update PortfolioProject.dbo.Nashville_Housing
set PropertSplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 

select OwnerAddress,
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.Nashville_Housing

-- alter and update table

alter table PortfolioProject.dbo.Nashville_Housing
add OwnerSplitAddress varchar(255)

update PortfolioProject.dbo.Nashville_Housing
set OwnerSplitAddress = parsename(replace(OwnerAddress,',','.'),3)


alter table PortfolioProject.dbo.Nashville_Housing
add OwnerSplitCity varchar(255)

update PortfolioProject.dbo.Nashville_Housing
set OwnerSplitCity = parsename(replace(OwnerAddress,',','.'),2)


alter table PortfolioProject.dbo.Nashville_Housing
add OwnerSplitState varchar(255)

update PortfolioProject.dbo.Nashville_Housing
set OwnerSplitState = parsename(replace(OwnerAddress,',','.'),1) 

-- update check 
select * from PortfolioProject.dbo.Nashville_Housing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct SoldAsVacant from PortfolioProject.dbo.Nashville_Housing

select distinct SoldAsVacant, count(SoldAsVacant)
from PortfolioProject.dbo.Nashville_Housing
group by SoldAsVacant
order by 2;

select SoldAsVacant,
		case when SoldAsVacant = 'Y' then 'Yes'
			 when SoldAsVacant = 'N' then 'No'
			 else SoldAsVacant
		end
from PortfolioProject.dbo.Nashville_Housing

UPDATE PortfolioProject.dbo.Nashville_Housing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant
				   END

-- cross check 
/*
SoldAsVacant	(No column name)
Yes					4675
No					51802
*/

--------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
select * from PortfolioProject.dbo.Nashville_Housing;

with RowNumCTE as (
select *,
		ROW_NUMBER() OVER(
		partition by ParcelID,
					 PropertyAddress,
					 SalePrice,
					 LegalReference
					 order by
						UniqueID
					 ) as row_num
from PortfolioProject.dbo.Nashville_Housing
-- order by ParcelID
)
select * from RowNumCTE
where row_num >1
order by PropertyAddress









---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select * from PortfolioProject.dbo.Nashville_Housing
order by ParcelID

alter table PortfolioProject.dbo.Nashville_Housing
drop column PropertyAddress,SaleDate,OwnerAddress,TaxDistrict



-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO

















