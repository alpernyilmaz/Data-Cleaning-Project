select * from ptpro

-- Correct date format

select SaleDateConverted , CONVERT(Date , Saledate)
from ptpro

update ptpro
set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE ptpro
Add SaleDateConverted Date;

Update ptpro
SET SaleDateConverted = CONVERT (Date,Saledate)


-- Generating Address to null values by ParselID

select PropertyAddress
from ptpro
where PropertyAddress is null
order by ParcelID

select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress ,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from ptpro a
join ptpro b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from ptpro a 
join ptpro b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]

-- Whole address to City , State , Address

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress )-1) as Address ,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress )+1 , LEN(PropertyAddress)) as State
from ptpro

ALTER TABLE ptpro
Add SplitAddress nvarchar(255);

Update ptpro
SET SplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress )-1)

ALTER TABLE ptpro
Add SplitCity nvarchar(255);

Update ptpro
SET SplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress )+1 , LEN(PropertyAddress))


-- Split Owner Address with PARSENAME

select 
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1)
from ptpro

ALTER TABLE ptpro
Add OwnerSplitAddress nvarchar(255);

Update ptpro
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3)

ALTER TABLE ptpro
Add OwnerSplitCity nvarchar(255);

Update ptpro
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2)

ALTER TABLE ptpro
Add OwnerSplitState nvarchar(255);

Update ptpro
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1)

-- SoldAsVacant optimizing

select DISTINCT(SoldAsVacant) , COUNT(SoldAsVacant)
from ptpro
group by SoldAsVacant
order by 2

select SoldAsVacant ,
CASE when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END 
from ptpro

UPDATE ptpro 
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END 

-- Deleting Unused Columns

select * 
from ptpro

ALTER TABLE ptpro 
DROP COLUMN OwnerAddress , PropertyAddress , TaxDistrict






















