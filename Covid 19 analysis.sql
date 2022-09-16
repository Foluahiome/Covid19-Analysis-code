/*
This is an exploratory analysis of the covid 19 deaths data relating to Nigeria, Africa etc
*/


--Select all data from covid_death table
SELECT *
FROM covid_deaths;

--Percentage of people dead
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS percentage_death
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location;

--Percentage death in Nigeria
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS percentage_death
FROM covid_deaths
WHERE location = 'Nigeria'
AND continent IS NOT NULL
ORDER BY date;

--Percentage death in United states
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS percentage_death
FROM covid_deaths
WHERE location LIKE '%states%' 
AND continent IS NOT NULL
ORDER BY date DESC;

--Percentage of people infected in Nigeria
SELECT location, date, population, total_cases, (total_cases/population)*100 AS percentage_infected
FROM covid_deaths
WHERE location = 'Nigeria'
AND continent IS NOT NULL
ORDER BY percentage_infected;

--Highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS max_cases, MAX((total_cases/population)*100) AS max_percentage_infected
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
HAVING MAX((total_cases/population)*100) IS NOT NULL
ORDER BY max_percentage_infected DESC;

--Highest death count by location 
SELECT location, MAX(CAST(total_deaths AS int)) AS max_deathcount
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY max_deathcount DESC;

--Lowest death count by location 
SELECT location, MIN(CAST(total_deaths AS int)) AS min_deathcount
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY min_deathcount DESC;



--Exploring data by continent

--Continent with highest infection rate compared to population
SELECT continent, population, MAX(total_cases) AS max_cases, MAX((total_cases/population)*100) AS max_percentage_infected
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent, population
ORDER BY max_percentage_infected DESC;

--Highest death count by continent
SELECT continent, MAX(CAST(total_deaths AS int)) AS max_deathcount
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY max_deathcount DESC;

--Total death count by continent
SELECT continent, SUM(CAST(total_deaths AS int)) AS sum_total_death
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY sum_total_death;


--Sum of hospital patients by continent
SELECT continent, SUM(CAST(hosp_patients AS int)) AS total_hospital_patients
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_hospital_patients;

--Total case of infected people between Jan-Oct 2022
SELECT continent, COUNT(total_cases) AS count_cases
FROM covid_deaths
WHERE continent IS NOT NULL 
AND date BETWEEN '2022-01-01' AND '2022-10-01'
GROUP BY continent
ORDER BY count_cases;


--Joining the 2 tables (Covid_deaths and covid_vaccines)

--View all data in covid_vaccines
SELECT *
FROM covid_vaccines;

--Join both tables using location and date
SELECT *
FROM covid_deaths AS cd
INNER JOIN covid_vaccines AS cv
ON cd.location = cv.location
AND cd.date = cv.date;

--Number ofnew vaccinations per day
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
FROM covid_deaths AS cd
INNER JOIN covid_vaccines AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY cd.location, cd.date;

---Number of new vaccinations in Africa daily 
SELECT cd.continent, cd.date, cd.population, cv.new_vaccinations
FROM covid_deaths AS cd
INNER JOIN covid_vaccines AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent = 'Africa' 
AND cv.new_vaccinations IS NOT NULL
ORDER BY cd.continent;


--Number of new vaccinations in Nigerian daily 
SELECT cd.location, cd.date, cv.new_vaccinations
FROM covid_deaths AS cd
INNER JOIN covid_vaccines AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.location = 'Nigeria'
AND cv.new_vaccinations IS NOT NULL
ORDER BY cd.location;

--Number of vaccinated people in Africa
SELECT cd.continent, cd.date, cv.people_vaccinated 
FROM covid_deaths AS cd
INNER JOIN covid_vaccines AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent = 'Africa'
AND cv.people_vaccinated IS NOT NULL
ORDER BY cd.continent;


--Number of Nigerians vaccinated per day
SELECT cd.location, cd.date, cv.people_vaccinated
FROM covid_deaths AS cd
INNER JOIN covid_vaccines AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.location = 'Nigeria'
AND cv.people_vaccinated IS NOT NULL
ORDER BY cd.location;


--Number of people vaccinated per day 
SELECT cd.continent, cd.location, cd.date, cv.people_vaccinated
FROM covid_deaths AS cd
INNER JOIN covid_vaccines AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY cd.location;


--Running total vaccinations for each location
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations AS int)) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date) AS runningtotal_vaccination
FROM covid_deaths AS cd
INNER JOIN covid_vaccines AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL 
ORDER BY cd.location, cd.date;



--Creating view to store for visualization

CREATE VIEW vaccinated_nigerians AS
SELECT cd.location, cd.date, cv.people_vaccinated
FROM covid_deaths AS cd
INNER JOIN covid_vaccines AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.location = 'Nigeria'
AND cv.people_vaccinated IS NOT NULL;


CREATE VIEW vaccinated_africans AS
SELECT cd.continent, cd.date, cv.people_vaccinated 
FROM covid_deaths AS cd
INNER JOIN covid_vaccines AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent = 'Africa'
AND cv.people_vaccinated IS NOT NULL;



CREATE VIEW nig_percentage_death AS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS percentage_death
FROM covid_deaths
WHERE location = 'Nigeria'
AND continent IS NOT NULL


CREATE VIEW highest_infection_rate As
SELECT continent, population, MAX(total_cases) AS max_cases, MAX((total_cases/population)*100) AS max_percentage_infected
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent, population