/*
Queries used for Tableau Project
*/


-- 1. Overall Death Percentage 

SELECT 
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths) / SUM(New_Cases) * 100 AS DeathPercentage
FROM
    projects.coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;

-- 2. Total death count per continent

-- Taking these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT 
    location, SUM(new_deaths) AS TotalDeathCount
FROM
    projects.coviddeaths
WHERE
    continent IS NULL
        AND location NOT IN ('World' , 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- 3. Location wise: Highest Infection rate

SELECT 
    Location,
    Population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    projects.coviddeaths
GROUP BY Location , Population
ORDER BY PercentPopulationInfected DESC;


-- 4. Location wise: Highest Infection rate with date


SELECT 
    Location,
    Population,
    date,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    projects.coviddeaths
GROUP BY Location , Population , date
ORDER BY PercentPopulationInfected DESC;





-- More queries


-- 1. Population that has received at least one Covid Vaccine

SELECT 
    d.continent,
    d.location,
    d.date,
    d.population,
    MAX(v.total_vaccinations) AS RollingPeopleVaccinated
FROM
    projects.coviddeaths d
        JOIN
    projects.covidvaccinations v ON d.location = v.location
        AND d.date = v.date
WHERE
    d.continent IS NOT NULL
GROUP BY d.continent , d.location , d.date , d.population
ORDER BY 1 , 2 , 3;




-- 2. Death percentage overall

SELECT 
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths) / SUM(New_Cases) * 100 AS DeathPercentage
FROM
    projects.coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;


-- 3. Death percentage overall

-- Taking these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT 
    location, SUM(new_deaths) AS TotalDeathCount
FROM
    projects.coviddeaths
WHERE
    continent IS NULL
        AND location NOT IN ('World' , 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;



-- 4. Percentage of Population Infected

SELECT 
    Location,
    Population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    projects.coviddeaths
GROUP BY Location , Population
ORDER BY PercentPopulationInfected DESC;



-- 5. Deaths per location

SELECT 
    Location, date, population, total_cases, total_deaths
FROM
    projects.coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;


-- 6. Using window function to get percentage of populaiton vaccinated at least once

WITH PopvsVac 
	(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT 
	d.continent, d.location, d.date, d.population, v.new_vaccinations, 
    SUM(v.new_vaccinations) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
FROM projects.coviddeaths d JOIN projects.covidvaccinations v
	ON d.location = v.location
	AND d.date = v.date
WHERE 
	d.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS PercentPeopleVaccinated
FROM 
	PopvsVac;


-- 7. Highest Infection per Location & Population

SELECT 
    Location,
    Population,
    date,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    projects.coviddeaths
GROUP BY Location , Population , date
ORDER BY PercentPopulationInfected DESC;

