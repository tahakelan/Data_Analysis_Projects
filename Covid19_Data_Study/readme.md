# Covid 19 - Data Exploration using MySQL & Visualization with Tableau


The dataset I used was taken from [Our World In Data](https://ourworldindata.org/explorers/coronavirus-data-explorer?zoomToSelection=true&time=2020-03-01..latest&country=USA~GBR~CAN~DEU~ITA~IND&region=World&pickerMetric=location&pickerSort=asc&Interval=7-day+rolling+average&Relative+to+Population=true&Metric=Confirmed+cases&Color+by+test+positivity=false). It contains information about confirmed cases, deaths, and other details from March 1, 2020 to the present.

Data used here for analysis: 
1. [Covid deaths data](https://github.com/tahakelan/Data_Analysis_Projects/blob/main/Covid19_Data_Study/covid_deathss.csv)
2. [Covid Vaccinations data](https://github.com/tahakelan/Data_Analysis_Projects/blob/main/Covid19_Data_Study/CovidVaccinationss.csv)

It contains information about:
- Country code
- Name of all countries
- Population of countries; total and segmented by age
- Date of record
- Daily total and new cases of Covid-19
- Daily total and new deaths due to Covid-19
- Total vaccinations and number of people vaccinated

I used SQL to query data, explore relationships between variables, and gain insights. I employed SQL Joins, CTEs, Temp Tables, Windows Functions, Aggregate Functions, and Views to understand:
- The likelihood of dying from COVID-19 infection
- The percentage of population affected by COVID-19 (total and by country)
- Countries with the highest infection rate relative to their population
- Countries with the highest death count relative to their population
- The total population versus vaccinations
- The percentage of population that has received at least one COVID-19 vaccine

After exploring the data, I used query results to create visualizations in Tableau highlighting:
- Overall Death Percentage
- Total Death per continent
- Percent Population Infected per Country
- Percent of Population Infected & Forecast (Major countries)

Find Tableau Visualization [here](https://public.tableau.com/app/profile/taha.elangovan/viz/Covid19DataBasicVisuals/Dashboard1).


---



*Learning resource: [Alex the Analyst](https://www.youtube.com/@AlexTheAnalyst)*.

