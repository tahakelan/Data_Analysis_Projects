/*
Cleaning Data in SQL Queries
*/

USE projects;

-- Viewing entire data
SELECT * FROM housing_data;

-- __________________________________________________ --

-- Standardizing Date Format
-- Checking 
SELECT 
    saleDate, CONVERT( SaleDate , DATE)
FROM
    housing_data;

-- Updating the Date column

ALTER TABLE housing_data
Add SaleDateConverted Date;

UPDATE housing_data 
SET 
    SaleDateConverted = CONVERT( SaleDate , DATE);

-- Checking
SELECT 
    SaleDateConverted
FROM
    housing_data;

-- __________________________________________________ --

-- Populating Property Address data

-- Viewing data with null PropertyAddress
SELECT 
    *
FROM
    housing_data
WHERE
    PropertyAddress IS NULL
ORDER BY ParcelID
;

/*
Observed parcel ID is unique for a PropertyAddress.
Using that to populate empty field for PropertyAddress
By joining table with itself 
*/

SELECT 
    a.ParcelID,
    a.PropertyAddress,
    b.ParcelID,
    b.PropertyAddress
    -- ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM
    housing_data a
        JOIN
    housing_data b ON a.ParcelID = b.ParcelID
        AND a.UniqueID <> b.UniqueID
WHERE
    a.PropertyAddress IS NULL;

-- Populating null fields

UPDATE housing_data a
        JOIN
    housing_data b ON a.ParcelID = b.ParcelID
        AND a.UniqueID <> b.UniqueID 
SET 
    a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE
    a.PropertyAddress IS NULL;


-- __________________________________________________ --



-- Breaking out Address into Individual Columns (Address, City, State)


SELECT 
    PropertyAddress
FROM
    housing_data;

SELECT 
    SUBSTRING(PropertyAddress,
        1,
        POSITION(',' IN PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress,
        POSITION(',' IN PropertyAddress) + 1,
        CHAR_LENGTH(PropertyAddress)) AS Address
FROM
    housing_data;


ALTER TABLE housing_data
ADD PropertySplitAddress varchar(255);

UPDATE housing_data 
SET 
    PropertySplitAddress = SUBSTRING(PropertyAddress,
        1,
        POSITION(',' IN PropertyAddress) - 1);


ALTER TABLE housing_data
ADD PropertySplitCity varchar(255);

UPDATE housing_data 
SET 
    PropertySplitCity = SUBSTRING(PropertyAddress,
        POSITION(',' IN PropertyAddress) + 1,
        CHAR_LENGTH(PropertyAddress));

-- Viewing all data
SELECT * FROM housing_data; 


SELECT 
    OwnerAddress
FROM
    housing_data;

-- Splitting Owner Address
-- PARSENAME function in SQL

SELECT 
    SUBSTRING_INDEX(OwnerAddress, ',', 1), 
    SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2),',',-1),
    SUBSTRING_INDEX(OwnerAddress, ',', -1)
FROM
    housing_data;

-- Address
ALTER TABLE housing_data
ADD OwnerSplitAddress VARCHAR(255);

UPDATE housing_data 
SET 
    OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

-- City
ALTER TABLE housing_data
ADD OwnerSplitCity VARCHAR(255);

UPDATE housing_data 
SET 
    OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2),',',-1);

-- State
ALTER TABLE housing_data
ADD OwnerSplitState VARCHAR(255);

UPDATE housing_data 
SET 
    OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', - 1);

-- Viewing
SELECT 
    *
FROM
    housing_data;

-- __________________________________________________ --


-- Changing Y and N to Yes and No in "Sold as Vacant" field
-- Usign CASE WHEN Statements

SELECT 
	DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM
    housing_data
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT 
    SoldAsVacant,
    CASE
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END AS Replacement
FROM
    housing_data;


UPDATE housing_data 
SET 
    SoldAsVacant = CASE
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END
;

-- __________________________________________________ --

-- Removing Duplicates from the dataset

-- Viewing duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) row_num
From housing_data
)
SELECT 
    *
FROM
    RowNumCTE
WHERE
    row_num > 1
ORDER BY PropertyAddress;


-- Removing duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) row_num
From housing_data
)
DELETE FROM RowNumCTE 
WHERE
    row_num > 1 ORDER BY PropertyAddress;

-- Viewing all data

SELECT * FROM housing_data;



-- __________________________________________________ --



-- Delete Unused Columns



ALTER TABLE housing_data
DROP COLUMN OwnerAddress,  
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate;


SELECT * FROM housing_data;
