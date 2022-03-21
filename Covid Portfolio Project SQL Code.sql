SELECT *
FROM covid..coviddeaths
WHERE continent is not null
ORDER BY location, date

--This will select the data that we are using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid..coviddeaths
ORDER BY location, date


-- Looking at Total Cases vs Total Deaths in the United States
-- Shows percent chance of survival
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid..coviddeaths
WHERE location LIKE '%states%'
ORDER BY location, date


-- Looking at Total Cases vs Population in the United States
-- Shows what percent of population contracted virus (does not account for people that have contracted virus more than once)
SELECT location, date, population, total_cases, (total_cases/population)*100 AS ContractionPercentage
FROM covid..coviddeaths
WHERE location LIKE '%states%'
ORDER BY location, date


-- Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) AS PercentPopulationInfected
FROM covid..coviddeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC


--Showing countries with highest death count per population
SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM covid..coviddeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC


--Showing continents with highest death count per population
SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM covid..coviddeaths
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathCount DESC


--Global numbers
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM covid..coviddeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2


--Looking at total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
FROM covid..coviddeaths dea
JOIN covid..covidvax vax
	ON dea.location = vax.location
	AND dea.date = vax.date
WHERE dea.continent is not null
ORDER BY 2, 3


--Creating view to store data for later visualizations
CREATE VIEW PercentSurvival AS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid..coviddeaths
WHERE continent is not null 

CREATE VIEW PercentContracted AS
SELECT location, date, population, total_cases, (total_cases/population)*100 AS ContractionPercentage
FROM covid..coviddeaths
WHERE continent is not null 

CREATE VIEW InfectionRate AS
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) AS PercentPopulationInfected
FROM covid..coviddeaths
WHERE continent is not null
GROUP BY population, location

CREATE VIEW DeathCount AS
SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM covid..coviddeaths
WHERE continent is not null
GROUP BY location

CREATE VIEW DeathCountContinent AS
SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM covid..coviddeaths
WHERE continent is not null 
GROUP BY continent

CREATE VIEW TotalVaccinations AS
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
FROM covid..coviddeaths dea
JOIN covid..covidvax vax
	ON dea.location = vax.location
	AND dea.date = vax.date
WHERE dea.continent is not null

