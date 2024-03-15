Select *
From CovidDeaths
Order by 3,4

Select *
From CovidVaccinations
Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Where continent is not null 
order by 1,2

Select Location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
From CovidDeaths
Where location = 'India'
and continent is not null 
order by 1,2

Select Location, date, total_cases, population, (cast(total_cases as float)/cast(population as float))*100 as PercentagePopulationInfected
From CovidDeaths
Where location = 'India'
and continent is not null 
order by 1,2

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max(cast(total_cases as float)/cast(population as float))*100 as PercentagePopulationInfected
From CovidDeaths
Group by Location, Population
order by PercentagePopulationInfected desc

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null 
Group By date
order by 1,2

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER 
(Partition by dea.location Order by dea.location, CONVERT(date, dea.date)) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
On dea.location = vac.location 
and dea.date = vac.date
Where dea.continent is not null
Order by 2, 3

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER 
(Partition by dea.location Order by dea.location, CONVERT(date, dea.date)) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac