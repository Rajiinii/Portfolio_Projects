select*
from Nashvillehousing

---To convert saledate column 
select SaleDate, convert(date,SaleDate)
from Nashvillehousing

update Nashvillehousing
set SaleDate=convert(date,SaleDate)

alter table Nashvillehousing
add saledateconverted date;

update Nashvillehousing
set saledateconverted=convert(date,saledate)


---To populate property address data

select propertyaddress
from nashvillehousing
where propertyaddress is null

select a.parcelID, a.propertyaddress, b.parcelID, b.propertyaddress, isnull(a.propertyaddress,b.propertyaddress)
from Nashvillehousing a
join Nashvillehousing b
on a.parcelID = b.parcelID
and a.uniqueId <> b.uniqueID
where a.propertyaddress is null


update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from Nashvillehousing a
join Nashvillehousing b
on a.parcelID = b.parcelID
and a.uniqueId <> b.uniqueID
where a.propertyaddress is null

select*
from Nashvillehousing
where propertyaddress is null


---To divide the Address into individual columns(Address,city)

select
substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as address,
substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress)) as city
from Nashvillehousing

alter table Nashvillehousing
add Address nvarchar(255);

update Nashvillehousing
set Address = substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

alter table Nashvillehousing
add City nvarchar(255);

update Nashvillehousing
set city = substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))

select
PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from Nashvillehousing


alter table Nashvillehousing
add ownersplitaddress nvarchar(255);

update Nashvillehousing
set ownersplitaddress = PARSENAME(replace(owneraddress,',','.'),3)

alter table Nashvillehousing
add ownercity nvarchar(255);

update Nashvillehousing
set ownercity = PARSENAME(replace(owneraddress,',','.'),2)


alter table Nashvillehousing
add ownerstate nvarchar(255);

update Nashvillehousing
set ownerstate = PARSENAME(replace(owneraddress,',','.'),1)

select*
from Nashvillehousing


---To change Y and N to Yes and No in soldasvacant column

select distinct soldasvacant, count(soldasvacant)
from Nashvillehousing
group by soldasvacant
order by 2


select soldasvacant,
CASE WHEN soldasvacant = 'Y' then 'Yes'
     WHEN soldasvacant = 'N' then 'No'
	 ELSE soldasvacant
	 END
from Nashvillehousing

update Nashvillehousing
set soldasvacant = CASE WHEN soldasvacant = 'Y' then 'Yes'
     WHEN soldasvacant = 'N' then 'No'
	 ELSE soldasvacant
	 END


---To Remove Duplicates

with duplicatesCTE as (
select *,
   row_number() over(
   partition by parcelID,
                propertyaddress,
				saleprice,
				saledate,
				legalreference
				order by 
				uniqueID
				)duplicates
from Nashvillehousing
)
delete
from duplicatesCTE
where duplicates >1

---To delete columns

alter table Nashvillehousing
drop column saledate,owneraddress,taxdistrict,propertyaddress

select*
from Nashvillehousing

