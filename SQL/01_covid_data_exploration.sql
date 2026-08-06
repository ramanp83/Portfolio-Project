select * from PortfolioProject..CovidDeaths
order by 3,4;

-- EXEC sp_help 'PortfolioProject..CovidDeaths'; -- describe CovidVaccinations table 

select * from PortfolioProject..CovidVaccinations
order by 3,4;

-- total death vs total death 
select location,date,total_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where location = 'india'
order by 1,2;

-- india country death percentage over time 
select 
	location,
	date,
	total_cases,
	total_deaths,
	round((total_deaths/total_cases)*100,2)as Death_percentage
from PortfolioProject..CovidDeaths
where location = 'india'
order by 2;

-- death percentage sorted by location and dates
select 
	location,
	date,
	population,
	total_cases,
	total_deaths,
	round((total_cases/population)*100,4)as Death_percentage	
from PortfolioProject..CovidDeaths
--where location = 'india'
order by 1,2;

-- count location wise infestion (Total_cases) and compare total_case with populaction
select  
	location,
	population,
	max(total_cases) as HighestInfection_Count,
	max(total_cases/population)*100 as Percecnt_Population_infected
from PortfolioProject..CovidDeaths
group by location,	population
order by Percecnt_Population_infected desc;


-- highest death in country 
select  
	location,
	MAX(cast(total_deaths as int)) as highest_death
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by highest_death desc;

-- highest death in country  where continents is not null 
select  
	location,
	MAX(cast(total_deaths as int)) as highest_death
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by highest_death desc;

select
	date,
	sum(new_cases) as  total_cases,
	sum(cast(new_deaths as int)) as total_death,
	sum(cast(new_deaths as int ))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2;

/*
select
	year(date),
	sum(new_cases) as  total_cases,
	sum(cast(new_deaths as int)) as total_death,
	sum(cast(new_deaths as int ))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by year(date)
order by 1,2;
*/
select
	sum(new_cases) as  total_cases,
	sum(cast(new_deaths as int)) as total_death,
	(sum(cast(new_deaths as int ))/sum(new_cases))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2;

select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as RollingPeoplecaViccantion
-- ,(RollingPeoplecaViccantion/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
 and dea.date=vac.date
where dea.continent is not null -- and vac.new_vaccinations is not null
order by 2,3;

-- with cte

with popVSvac (continent,location , date, population, new_vaccinations,RollingPeopleVaccinated)
as (
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as RollingPeoplecaViccanted
-- ,(RollingPeoplecaViccanted/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
 and dea.date=vac.date
where dea.continent is not null -- and vac.new_vaccinations is not null
-- order by 2,3;
)
select *,(RollingPeopleVaccinated/population)*100
from popVSvac;


-- Temp Table
drop table if exists #percentpopulcationvaccinated
create table #percentpopulcationvaccinated
(continent varchar(255),
location varchar (255),
date datetime,
populaction  numeric,
new_vaccinations numeric,
RollingPeoplecaViccanted numeric)


insert into #percentpopulcationvaccinated
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as RollingPeoplecaViccanted
-- ,(RollingPeoplecaViccanted/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
 and dea.date=vac.date
--where dea.continent is not null -- and vac.new_vaccinations is not null
-- order by 2,3;
select *,(RollingPeoplecaViccanted/populaction)*100
from #percentpopulcationvaccinated

create view percentpopulcationvaccinated AS
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as RollingPeoplecaViccanted
-- ,(RollingPeoplecaViccanted/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
 and dea.date=vac.date
where dea.continent is not null -- and vac.new_vaccinations is not null
-- order by 2,3; 
;

select * from percentpopulcationvaccinated;