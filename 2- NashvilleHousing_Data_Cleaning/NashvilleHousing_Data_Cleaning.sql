/*
select *
from NashvilleHousing
*/


-- Standardize Date Format
/*
select SaleDate, CONVERT(date, SaleDate)
from NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateCleaned Date

UPDATE NashvilleHousing
SET SaleDateCleaned = CONVERT(date, SaleDate)
*/


-- Populate Property Address Data
/*
select ParcelID, PropertyAddress
from NashvilleHousing
order by ParcelID

select n1.ParcelID, n1.PropertyAddress, n2.ParcelID, n2.PropertyAddress, ISNULL(n1.PropertyAddress, n2.PropertyAddress)
from NashvilleHousing n1
join NashvilleHousing n2
	on n1.ParcelID = n2.ParcelID
	and n1.UniqueID <> n2.UniqueID
where n1.PropertyAddress is null

update n1
set n1.PropertyAddress= ISNULL(n1.PropertyAddress, n2.PropertyAddress)
						from NashvilleHousing n1
						join NashvilleHousing n2
							on n1.ParcelID = n2.ParcelID
							and n1.UniqueID <> n2.UniqueID
						where n1.PropertyAddress is null
*/


-- Replace Double Spaces to One Space in PropertyAddress
/*
select PropertyAddress, REPLACE(PropertyAddress, '  ', ' ')
from NashvilleHousing

alter table NashvilleHousing
add PropertyAddress2 varchar(255)

update NashvilleHousing
set PropertyAddress2 = REPLACE(PropertyAddress, '  ', ' ')
*/


-- Breaking out PropertyAddress2 into Individual Columns (Address, City)
/*
select PropertyAddress2, SUBSTRING(PropertyAddress2, 1, CHARINDEX(',', PropertyAddress2, 1) - 1),
	SUBSTRING(PropertyAddress2, CHARINDEX(',', PropertyAddress2, 1) + 1, LEN(PropertyAddress2)) 
from NashvilleHousing

alter table nashvillehousing
add PropertySplitAddress Varchar(255)

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress2, 1, CHARINDEX(',', PropertyAddress2, 1) - 1)

alter table nashvillehousing
add PropertySplitCity Varchar(255)

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress2, CHARINDEX(',', PropertyAddress2, 1) + 1, LEN(PropertyAddress2)) 
*/


-- Replace Double Spaces to One Space in OwnerAddress
/*
select OwnerAddress, REPLACE(OwnerAddress, '  ', ' ')
from NashvilleHousing

alter table NashvilleHousing
add OwnerAddress2 varchar(255)

update NashvilleHousing
set OwnerAddress2 = REPLACE(OwnerAddress, '  ', ' ')
*/


-- Breaking out OwnerAddress2 into Individual Columns (Address, City, State)
/*
select OwnerAddress2,
	PARSENAME(replace(OwnerAddress2, ',', '.'), 3),
	PARSENAME(replace(OwnerAddress2, ',', '.'), 2),
	PARSENAME(replace(OwnerAddress2, ',', '.'), 1)
from NashvilleHousing

alter table NashvilleHousing
Add OwnerSplitAddress varchar(255)

alter table NashvilleHousing
Add OwnerSplitCity varchar(255)

alter table NashvilleHousing
Add OwnerSplitState varchar(255)

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress2, ',', '.'), 3)

update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress2, ',', '.'), 2)

update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress2, ',', '.'), 1)
*/


-- Change Y and N to Yes and No in "Sold as Vacant" field
/*
select SoldAsVacant, COUNT(*)
from NashvilleHousing
group by SoldAsVacant

select SoldAsVacant, 
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
from NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
				        WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END
*/


-- Remove Duplicates
/*
select ParcelID, PropertyAddress2, SaleDateCleaned, LegalReference, COUNT(*)
from NashvilleHousing
group by ParcelID, PropertyAddress2, SaleDateCleaned, LegalReference
having COUNT(*) > 1


with RowNumCte as (
	select *, ROW_NUMBER() OVER(Partition By ParcelID, PropertyAddress2, SaleDateCleaned, LegalReference 
								Order By UniqueID) row_num
	from NashvilleHousing)

select *
from RowNumCte
where row_num > 1
*/


-- Delete Unused Columns
/*
select *
from NashvilleHousing

Alter Table NashvilleHousing
Drop Column  PropertyAddress, PropertyAddress2, SaleDate, OwnerAddress, OwnerAddress2
*/
