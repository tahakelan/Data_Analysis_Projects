# Nashville Housing Dataset - Data Cleaning Practice Project 

The purpose of this project is to practice data cleaning using MySQL & present the dataset in a better & usable format. This [dataset](https://github.com/tahakelan/Data_Analysis_Projects/blob/b2d6e56105fb71c2ce30f97d4d97b5eb0234a3c1/Data_cleaning_Nashville_Housing/Nashville_Housing_Data.xlsx) contains information about housing properties and their sales data, including:
- Unique ID
- Parcel ID
- Property Address
- Sale Price
- Owner Name and Address
- Land Value
- Attributes of the house

After importing the data into MySQL the following data cleaning activities were done:
- [Standardizing Date Format](#standardizing-date-format)
- [Tackling NULL Values in Property Address](#tackling-null-values-in-property-address)
- [Splitting Property Address](#splitting-property-address)
- [Splitting Owner Address](#splitting-owner-address)
- [Making data uniform](#making-data-uniform)
- [Removing Duplicates from the dataset](#removing-duplicates-from-the-dataset)
- [Delete Unused Columns](#delete-unused-columns)

***

#### Standardizing Date Format
- The sale date is in the format `YYYY-MM-DD HH:MM:SS:SSS`, which I'll convert to the standard date format `YYYY-MM-DD` using the `CONVERT` function.
#### Tackling NULL Values in Property Address 
- We observe NULL values in the `PropertyAddress` column.
- To check if there are any correlations between `PropertyAddress` and other columns, we observe that the `parcel ID` is unique for each `PropertyAddress`.
- We can use this correlation to populate empty fields in `PropertyAddress` by performing a self join.
#### Splitting Property Address 
- It is observed that address has city after a comma. We can use `SUBSTRING`  function to read the address & the city separately with ‘,’ as the delimiter here.
-     `SUBSTRING`(`PropertyAddress`, 1, `POSITION`(',' `IN` `PropertyAddress`) - 1) as the Address
-     `SUBSTRING`(`PropertyAddress`, `POSITION`(',' `IN` `PropertyAddress`) + 1, `CHAR_LENGTH`(`PropertyAddress`)) as the City
- We’ll put the split data into two different columns
#### Splitting Owner Address
- We observe that address has the address, city & the state separated by comma. We can use `SUBSTRING_INDEX` to read them separately.
-     `SUBSTRING_INDEX`(`OwnerAddress`, ',', 1) as Address
-     `SUBSTRING_INDEX`(`SUBSTRING_INDEX`(`OwnerAddress`, ',', 2),',',-1) as City
-     `SUBSTRING_INDEX`(`OwnerAddress`, ',', - 1) as State
- We’ll put the split data into three different columns
#### Making data uniform
- We observe that  `SoldAsVacant` contains non-uniform data (N, Y, No, Yes). We can standardize it to only Yes and No using `CASE WHEN` statements.
#### Removing Duplicates from the dataset
- We can use the `Window` function to check for duplicates. To do this, we perform `ROW_NUMBER()` over a `PARTITION BY` of columns: `ParcelID`, `PropertyAddress`, `SalePrice`, `SaleDate`, `LegalReference`, and `UniqueID`.
- Duplicate rows will have a row number greater than one. We can then eliminate them by using the previous query as a CTE.
#### Delete Unused Columns
- We can `DROP` the column we do not need.
- Here, I’ve dropped `OwnerAddress`(Originally in the dataset), `PropertyAddress`(Originally in the dataset), `SaleDate`


---

Learning Resource: [AlexTheAnalyst](https://www.youtube.com/@AlexTheAnalyst)
