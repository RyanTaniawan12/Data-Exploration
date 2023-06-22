
select * from CovidDeaths
order by 3,4

select * from CovidVaccinations
order by 3,4

-- Select Data the we will be using

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
where continent is not null
order by 1,2

-- Total Deaths vs Total Cases (Death Percentage)

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null
order by 1,2

-- Death Percentage in a Country (Italy)
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null
and location like 'Italy'
order by 1,2

-- Total Cases vs Total Population in a Country (Italy)
-- Infection Rate of a Country Population
select location, date, total_cases, population, (total_cases/population)*100 as InfectionRate
from CovidDeaths
where continent is not null
where location like 'Italy'
order by 1,2

-- Finding Countries with the Highest Infection Rate
select location, date, population, max(total_cases) as HighestTotalCases, max((total_cases/population)*100) as PopulationInfectionRate
from CovidDeaths
where continent is not null
group by location, population, date
order by PopulationInfectionRate desc

-- Finding Countries with the Highest Death Count
select location, max(cast(total_deaths as int)) as DeathCount
from CovidDeaths
where continent is not null
group by location
order by DeathCount desc

-- Death Count By Location
select location, max(cast(total_deaths as int)) as DeathCount
from CovidDeaths
where continent is null
group by location
order by DeathCount desc

-- Continent with the Highest Death Count
select continent, max(cast(total_deaths as int)) as DeathCount
from CovidDeaths
where continent is not null
group by continent
order by DeathCount desc

-- Daily New Cases Worldwide
select date, sum(new_cases)
from CovidDeaths
where continent is not null
group by date
order by 1,2

-- Daily New Deaths Compared to New Cases Worldwide
select date, sum(new_cases) as DailyNewCases, sum(cast(new_deaths as int)) as DailyNewDeaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DailyDeathPercentage
from CovidDeaths
where continent is not null
group by date
order by 1,2

-- Global Total Cases
select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from CovidDeaths
where continent is not null
order by 1,2


-- Total Population vs Vaccinated Population
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as CumulativeVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Daily Vaccination Percentage vs Population with CTE
with PopvsVac as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as CumulativeVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)

select *, (CumulativeVaccinated/population)*100 as VaccinatedPercentage
from PopvsVac


-- Daily Vaccination Percentage vs Population with Temp Table
drop table if exists #VacPercentage 

create table #VacPercentage (
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
CumulativeVaccinated numeric
)

insert into #VacPercentage
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as CumulativeVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *, (CumulativeVaccinated/population)*100 as VaccinatedPercentage
from #VacPercentage

-- Create View for Daily Vaccination Percentage vs Population
create view VacPercentage as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as CumulativeVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


select * from VacPercentage