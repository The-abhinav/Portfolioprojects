select * 
from Covid..covid_deaths$
where continent is not null
order by 3, 4

--select * 
--from Covid..covid_vaccine$
--order by 3, 4

select location , date, total_cases, new_cases, total_deaths, population
from Covid..covid_deaths$
where continent is not null
order by 1, 2

select location , date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as
Deathpercentage
from Covid..covid_deaths$
where location = 'India'

order by 1, 2


--total cases vs population
select location , date,population , total_cases,  (total_cases/population)*100 as
casespercentage
from Covid..covid_deaths$
--where location = 'India'
order by 1, 2

--countries with highest infection rate compared to population
select location , population , max(total_cases) as HighestInfectionCount,  max((total_cases/population)*100) as
HeighestCasesPercentage
from Covid..covid_deaths$
--where location = 'India'
group by location , population
order by HeighestCasesPercentage desc

--countries with heighest death counts per population
select continent,  max(cast(total_deaths as int)) as TotalDeathCount
from Covid..covid_deaths$
--where location = 'India'
where continent is not null
group by continent 
order by TotalDeathCount desc 


-- Global Numbers
select  date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage   --, total_cases,  total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from Covid..covid_deaths$
--where location = 'India'
where continent is not null
group by date
order by 1, 2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 



select*
from PercentPopulationVaccinated
