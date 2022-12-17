use projects;

/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT * FROM coviddeaths
ORDER BY 3 , 4;

-- Covid deaths vaccinations table
SELECT * FROM covidvaccinations
ORDER BY 3 , 4;

-- Selecting Data for use from covid deaths table
SELECT 
    Location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    projects.coviddeaths
ORDER BY 1 , 2;

-- Checking total cases vs total deaths, country wise
-- To understand likelihood of dying in case of covid contraction
SELECT 
    location,
    total_cases,
    total_deaths,
    ROUND((total_deaths / total_cases) * 100, 2) AS Death_Percentage
FROM
    projects.coviddeaths
GROUP BY location
ORDER BY 4 DESC;

-- Checking for a specific country
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    ROUND((total_deaths / total_cases) * 100, 2) AS Death_Percentage
FROM
    projects.coviddeaths
WHERE
    location LIKE '%states%'
ORDER BY 4 DESC;

-- Percentage of population affected by covid
SELECT 
    Location,
    date,
    Population,
    total_cases,
    ROUND((total_cases / population) * 100, 2) AS 'Population_Infected(%)'
FROM
    projects.coviddeaths
ORDER BY 4 DESC;

-- Countries with Highest Infection Rate with respect to their population
SELECT 
    location,
    population,
    MAX(total_cases) AS 'Highest Infection Count',
    MAX(ROUND((total_cases / population) * 100, 2)) AS 'Population_Infected (in %)'
FROM
    projects.coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY 4 DESC;

-- Countries with Highest Death count with respect to population
SELECT 
    location,
    MAX(total_deaths) AS 'Highest Death Count',
    ROUND(MAX(total_deaths / population) * 100, 2) AS 'Population_Infected (in %)'
FROM
    projects.coviddeaths
GROUP BY location
ORDER BY 2 DESC;
/* This gives some output for continents in place of location. 
Observing the database we see that location is gives as continent where continent is null
*/

SELECT 
    location,
    MAX(total_deaths) AS 'Highest Death Count',
    ROUND(MAX(total_deaths / population) * 100, 2) AS 'Population_Infected (in %)'
FROM
    projects.coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;

-- BREAKING THINGS DOWN BY CONTINENT

SELECT 
    continent,
    MAX(CAST(Total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM
    projects.coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;



-- Global numbers

SELECT 
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    ROUND(SUM(new_deaths) / SUM(New_Cases) * 100,
            2) AS 'Death Percentage'
FROM
    projects.coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;



-- Total Population vs Vaccinations

SELECT 
    d.continent,
    d.location,
    d.date,
    d.population,
    v.new_vaccinations
FROM
    projects.coviddeaths d
        JOIN
    projects.covidvaccinations v ON d.location = v.location
        AND d.date = v.date
WHERE
    d.continent IS NOT NULL
ORDER BY 2 , 3;



-- Percentage of Population that has recieved at least one Covid Vaccine

Select 
	d.continent, d.location, d.date, d.population, 
    v.new_vaccinations, 
    sum(v.new_vaccinations) OVER (Partition by d.location order by d.location,d.date) as Vaccinated_People_Rolling,
    
from projects.coviddeaths d
join projects.covidvaccinations v
	On d.location = v.location and d.date = v.date
where d.continent is not null 
order by 2,3;

/* To run the above query correctly,
 using CTE to perform Calculation on Partition By in previous query
 Note to self: Number of columns must match number of columns in CTE
*/


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Vaccinated_People_Rolling)
as
(
Select d.continent, d.location, d.date, d.population, 
v.new_vaccinations, 
SUM(v.new_vaccinations) OVER (Partition by d.Location Order by d.location, d.Date) as Vaccinated_People_Rolling
-- ,(Vaccinated_People_Rolling/population)*100
from projects.coviddeaths d
join projects.covidvaccinations v
	On d.location = v.location and d.date = v.date
where d.continent is not null 
-- order by 2,3
)
Select *, round((Vaccinated_People_Rolling/Population)*100,2) as '% of people vaccinated - Rolling'
From PopvsVac;



-- Using Temp Table to perform Calculation on Partition By in previous query

use projects;
DROP Table if exists PercentPopulationVaccinated;
Create Table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population bigint,
New_vaccinations double,
Vaccinated_People_Rolling double
);

Insert into PercentPopulationVaccinated
Select d.continent, d.location, d.date, d.population, 
v.new_vaccinations, 
SUM(v.new_vaccinations) OVER (Partition by d.Location Order by d.location, d.Date) as Vaccinated_People_Rolling
-- ,(Vaccinated_People_Rolling/population)*100
from projects.coviddeaths d
join projects.covidvaccinations v
	On d.location = v.location and d.date = v.date
where d.continent is not null 
-- order by 2,3
;

-- Selecting all data from temp table
Select *, (Vaccinated_People_Rolling/Population)*100
From PercentPopulationVaccinated;


-- Creating View to store data for later visualizations

Create View PercentPopVaccinated as
Select d.continent, d.location, d.date, d.population, 
v.new_vaccinations, 
SUM(v.new_vaccinations) OVER (Partition by d.Location Order by d.location, d.Date) as Vaccinated_People_Rolling
-- ,(Vaccinated_People_Rolling/population)*100
from projects.coviddeaths d
join projects.covidvaccinations v
	On d.location = v.location and d.date = v.date
where d.continent is not null 
-- order by 2,3
;


-- Selecting everything from view

select * from percentpopvaccinated;
