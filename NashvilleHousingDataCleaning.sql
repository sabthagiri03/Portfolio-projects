select*
from portfolioProject..nashvilleHousing

--Standardize Data Format
select ConvertedSaleDate,convert(date,saleDate)
from portfolioproject..nashvilleHousing

update NashvilleHousing
set Saledate=convert(date,Saledate)

Alter table NashvilleHousing
add ConvertedSaleDate Date

update NashvilleHousing
set ConvertedSaleDate=convert(Date,Saledate)

--Populate Property Address

select *
from portfolioProject..NashvilleHousing
--where propertyAddress is null
order by parcelid

select a.parcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
isnull(a.propertyAddress,b.PropertyAddress)
from portfolioProject.dbo.nashvilleHousing a
join portfolioProject.dbo.nashvilleHousing b
on a.parcelID=b.parcelID and 
a.[uniqueID]<>b.[uniqueID]
where a.propertyAddress is null

update a
set propertyAddress=isnull(a.propertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join portfolioProject..nashvilleHousing b
on a.parcelID=b.ParcelID and a.[uniqueID ]<>b.[UniqueID ]
where a.propertyAddress is null

--breakout the Address into Individual Columns (Address,State,City)

select Propertyaddress
from portfolioproject.dbo.NashvilleHousing

select 
Substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address,
substring(propertyAddress,charindex(',',propertyAddress)+1,len(propertyAddress)) as Address
from portfolioProject..Nashvillehousing

alter Table NashvilleHousing
add PropertySplitAddress nvarchar(255)

update nashvilleHousing
set propertySplitAddress=Substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)

alter Table NashvilleHousing
add PropertySplitCity nvarchar(255)

update nashvilleHousing
set PropertySplitCity=Substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))


select OwnerAddress
from Portfolioproject..nashvilleHousing
select
--parsename(Replace(OwnerAddress,',','.'),1),
--parsename(replace(ownerAddress,',','.'),2),
--parsename(replace(ownerAddress,',','.'),3)
parsename(replace(ownerAddress,',','.'),3)'SplitAddress',
parsename(replace(OwnerAddress,',','.'),2)'SplitCity',
parsename(Replace(OwnerAddress,',','.'),1)'SplitState'
from portfolioProject..NashvilleHousing

alter Table NashvilleHousing
add OwnerSplitAddress nvarchar(255)

update nashvilleHousing
set OwnerSplitAddress=parsename(replace(ownerAddress,',','.'),3)

alter Table NashvilleHousing
add OwnerSplitCity nvarchar(255)

update nashvilleHousing
set OwnerSplitCity=parsename(replace(OwnerAddress,',','.'),2)

Alter table NashvilleHousing
add OwnerSplitState nvarchar(255)

update NashvilleHousing
set OwnerSplitState=parsename(replace(ownerAddress,',','.'),1)

--change Y and N as Yes and No

select distinct soldasVacant,count(soldasvacant)
from PortfolioProject..nashvilleHousing
group by soldasvacant
order by 2

select soldasvacant,
case when soldasvacant='Y' then 'Yes'
     when soldasvacant='N' then 'No'
	 else soldasvacant
end 
from portfolioProject..nashvilleHousing

update nashvilleHousing
set soldasvacant = case when soldasvacant='Y' then 'Yes'
     when soldasvacant='N' then 'No'
	 else soldasvacant
end 

--Remove Duplicates

with Row_numCTE as(
select *,row_number() over( partition by parcelID,PropertyAddress,LegalReference,saledate,saleprice
order by UniqueID)Roww
from PortfolioProject..NashvilleHousing)
select *
from Row_numCTE
where roww>1

with Row_numCTE as(
select *,row_number() over( partition by parcelID,PropertyAddress,LegalReference,saledate,saleprice
order by UniqueID)Roww
from PortfolioProject..NashvilleHousing)
select*From row_numCTE
where roww>1

with Row_numCTE as(
select *,row_number() over( partition by parcelID,PropertyAddress,LegalReference,saledate,saleprice
order by UniqueID)Rowww
from PortfolioProject..NashvilleHousing)
Select*
from row_numCTE
where rowww>1


with Row_numCTE as(
select *,row_number() over( partition by parcelID,PropertyAddress,LegalReference,saledate,saleprice
order by UniqueID)Rowww
from PortfolioProject..NashvilleHousing)
delete
from row_numCTE
where rowww>1

-- Delete Not used Columns

select *
from PortfolioProject..nashvilleHousing

Alter table portfolioProject..NAshvilleHousing
drop column OwnerAddress,PropertyAddress

Alter table portfolioProject..NAshvilleHousing
drop column Saledate

