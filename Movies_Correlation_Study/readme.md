# Movies Correlation Study

The [Movie Industry](https://github.com/tahakelan/Data_Analysis_Projects/blob/46203320698441a28390552bf43f6fdcc5c3634a/Movies_Correlation_Study/movies.csv) dataset from Kaggle is used here to perform this analysis. The dataset includes details about the movies, such as:

- Movie name, Released date, Runtime
- Rating, Genre
- Director,Writer, Country
- Budget, Gross, Company
- Runtime and some more details..

Libraries used here:  `pandas`, `numpy`, `seaborn`

Once we have imported the libraries & have loaded the csv of the dataset, we can start the analysis.

## Preliminary checks - Data cleaning:

- Checking for missing data
- Checking for duplicates
- Checking for outliers

## Performing data exploration to understand the data:

- Gross earnings & budget: How are they related? Does budget have any impact on the earnings it brings in?
    - Using scatterplot & regplot (Plot the data and a linear regression model fit) to understand the correlation between these two features.
- How are Score & Gross earnings related? Does higher score translate to higher earnings?
- Understanding correlations between numeric features using correlation matrix.
    - Higher number indicates a higher correlation between the two features. As we had checked earlier, Budget has a high correlation with gross earnings.
    - Numerising non-numeric columns to understand the overall correlation between all the columns
- Which are the companies with high gross revenue?

## Observations

- We observe that Votes & Budget have the highest correlation to the Gross Earnings

The entire analysis & the visualization can be seen [here](https://github.com/tahakelan/Data_Analysis_Projects/blob/ffafbdc73a76286e14e69328da35826c221e49f1/Movies_Correlation_Study/Movie-Correlation-Study.ipynb).

---

Learning resource: [AlextheAnalyst](https://www.youtube.com/@AlexTheAnalyst)
