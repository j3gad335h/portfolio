Select *
from Portfolio ..Covid
order by 3,4

Select location,date,total_cases,new_cases,total_deaths,new_deaths,total_vaccinations,people_vaccinated,people_fully_vaccinated,population
from Portfolio ..Covid
order by 1,2

-- Total Cases vs Total Deaths
Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from Portfolio ..Covid
order by 1,2

Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from Portfolio ..Covid
where location like '%India'
order by 5 DESC;

-- Total Cases vs Population
Select location,date,total_cases,population, (total_cases/population)*100 as 'Chance of getting Contracted'
from Portfolio ..Covid
--where location like '%roe Islands'
order by 1,2 

--Highest Infection Rate
Select location,max(cast(total_cases as int)) as Highest_Cases,population, max((total_cases/population))*100 as 'Infection Rate'
from Portfolio ..Covid
where continent is not null
--where location like '%India'
group by location,population
order by 4 desc

--Highest Death Rate
--Convert to integer
Select location,max(cast(total_deaths as int)) as Highest_Death_Count,population, max((total_deaths/population))*100 as 'Death Rate'
from Portfolio ..Covid
--where location like '%India'
where continent is not null
group by location,population
order by 4 desc

Select *
from Portfolio..Vac


--Merging Csv 

Select *
from Portfolio..Covid cov
join Portfolio..Vac vac
	on cov.location = vac.location
	and cov.date = vac.date

Select cov.continent,cov.location, max(vac.total_vaccinations)as Total_Vac,cov.population, max((vac.total_vaccinations/cov.population))*100 as Vac_Percentage
from Portfolio..Covid cov
join Portfolio..Vac vac
	on cov.location = vac.location
	and cov.date = vac.date
where cov.continent is not NULL
	and cov.population is not null
group by cov.continent,cov.location,cov.population
order by 5


--Testing
Select cov.continent,cov.location, max(cast(vac.total_vaccinations as bigint))as Total_Vac,cast(cov.population as bigint) as Population, max((vac.total_vaccinations/cov.population))*100 as Vac_Percentage
from Portfolio..Covid cov
join Portfolio..Vac vac
	on cov.location = vac.location
	and cov.date = vac.date
where cov.continent is not NULL
	and cov.population is not null
group by cov.continent,cov.location,cov.population
order by 1 desc


	




