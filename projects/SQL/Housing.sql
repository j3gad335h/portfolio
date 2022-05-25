Select * from Portfolio..Housing


--Standardize date 

alter table housing
alter column SaleDate Date

--Populate Address

Select a.PropertyAddress,a.ParcelID,b.PropertyAddress,b.ParcelID
from Portfolio..Housing a
join Portfolio..Housing b
	on  a.ParcelID=b.ParcelID
where	a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from Portfolio..Housing a
join Portfolio..Housing b
	on  a.ParcelID=b.ParcelID
	and	a.[UniqueID ]<>b.[UniqueID ]
where	a.PropertyAddress is null  

--Breaking out Address 

Select
	SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Address,
	SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))as City
from Portfolio..Housing

	--Use Portfolio --If Permission denied use this command to update the database location
Alter Table housing
Add SplitAddress nvarchar(255);

Alter Table Housing
Add SplitCity nvarchar(255);

Update Housing
set SplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
Update Housing
set SplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

Select * from Housing

--Split Owner Address using Parsename
	--Parsename Only works with Periods.Replace function used to replace comma into Period,So that we can use Parsename function
Select
	PARSENAME(Replace(Owneraddress,',','.'),3) as SplitOwnerAddress, 
	PARSENAME(Replace(Owneraddress,',','.'),2)as SplitOwnerCity, 
	PARSENAME(Replace(Owneraddress,',','.'),1)as SplitOwnerState 
from Housing
	--Updating the Column

Alter Table housing
Add SplitOwnerAddress nvarchar(255);
Alter Table Housing
Add SplitOwnerCity nvarchar(255);
Alter Table Housing
Add SplitOwnerState nvarchar(255);

Update Housing
set SplitOwnerAddress=PARSENAME(Replace(Owneraddress,',','.'),3)
Update Housing
set SplitOwnerCity=PARSENAME(Replace(Owneraddress,',','.'),2)
Update Housing
set SplitOwnerState=PARSENAME(Replace(Owneraddress,',','.'),1)

--Change 'Y' and 'N' status as Yes and No in SoldAsVacant Column

Select distinct(SoldAsVacant),count(SoldAsVacant)
from Housing
group by SoldAsVacant

Update Housing
Set SoldAsVacant=
	CASE When SoldAsVacant='Y' then 'Yes'
		 When SoldAsVacant='N' then 'No'
	ElSE SoldAsVacant
	END

--Remove Duplicates

Select * from Housing

With Row_Num as (
Select *,
	ROW_NUMBER() over(
	Partition by ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
	Order by UniqueID) row_num
from Housing)
Select * from Row_Num   -- Replace Select* with Delete to Delete those Duplicates
where row_num >1


--Delete Unused Columns

Alter Table Housing 
drop column OwnerAddress,PropertyAddress,TaxDistrict

Select * from Housing

--Data Cleaning Finished
Select [UniqueID ],ParcelID,LandUse,LandValue,BuildingValue,SalePrice,SaleDate
from Housing