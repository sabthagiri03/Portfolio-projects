select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4
select *
from PortfolioProject..CovidVaccinations
where continent is not null
order by 3,4


select Location,Date,Total_cases,new_cases,Total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null

select Location,Date,Total_cases,Total_deaths,(total_deaths/Total_cases)*100 'Death Percentage'
from PortfolioProject..CovidDeaths
where location like '%india%' and continent is not null
order by date

select location,date,total_cases,Total_Deaths,(total_cases/population)*100 'Case Percentage'
from PortfolioProject..CovidDeaths
where location='India' and continent is not null
order by Date

select location,population,max(Total_cases) as HighestInfectedCount,
max(cast(Total_deaths as int))*100 as HighestDeathCount,
max((Total_cases/population)) as HighestInfectedpercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by population,Location
--order by HighestInfectedpercentage desc
--order by HighestDeathCount desc
order by highestInfectedCount desc

select Continent,max(total_cases) as HighestInfectedCount,
max(cast(Total_Deaths as int)) as 'Death Count'
from portfolioProject..CovidDeaths
where continent is not null
group by Continent
order by 'Death Count' asc


select date,sum(total_cases)TotalCases,sum(cast(Total_deaths as int)) TotalDeath,
sum(cast(total_deaths as int))/sum(Total_cases)*100 as 'Death Percent'
from PortfolioProject..covidDeaths
where continent is not null
group by date
order by 1

with PopvsVac (continent,location,date,population,New_vaccinations,rollingPeopleVaccinated)
as
(

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) 
over(partition by dea.location order by dea.location,dea.date) 
as rollingPeopleVaccinated
from portfolioproject..covidvaccinations vac
join PortfolioProject..covidDeaths dea
on vac.date = dea.date and
vac.location=dea.location
where dea.continent is not null
--order by 2,3
)
select *,(rollingPeopleVaccinated)/population*100'RollingPeopleVaccinated Percent'
from PopvsVac

drop table if exists #percentPeoplevaccinated
create table #PercentPeopleVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date Datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPeopleVaccinated 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) 
over(partition by dea.location order by dea.location,dea.date) 
as rollingPeopleVaccinated
from portfolioproject..covidvaccinations vac
join PortfolioProject..covidDeaths dea
on vac.date = dea.date and
vac.location=dea.location
where dea.continent is not null
--order by 2,3

select *,RollingPeoplevaccinated/Population*100'PeopleVccinatedPercent'
from #percentPeopleVaccinated

create view PercentPeopleVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) 
over(partition by dea.location order by dea.location,dea.date) 
as rollingPeopleVaccinated
from portfolioproject..covidvaccinations vac
join PortfolioProject..covidDeaths dea
on vac.date = dea.date and
vac.location=dea.location
where dea.continent is not null
--order by 2,3
