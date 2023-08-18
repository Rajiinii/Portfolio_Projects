--select *
--from covid_deaths

select*
from covid_vaccinations
order by 3,4

ALTER TABLE covid_deaths
DROP COLUMN population

select* 
from covid_deaths
order by 3,4

---select the data that i am going to use 

select location,date,total_cases,new_cases,total_deaths,population
from covid_deaths
order by 1,2

---To change datatype of total_deaths

alter table covid_deaths
alter column total_deaths float

---To change datatype of total_cases

alter table covid_deaths
alter column total_cases float

---total cases vs total deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from covid_deaths
order by 1,2

---By using where condition to filter the data

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from covid_deaths
where location ='United states'
order by 1,2

---By using like operator to find united states death percentage

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from covid_deaths
where location like '%states'
order by 1,2

---total_cases vs population

select location,date,total_cases,population,(total_cases/population)*100 as covidpercentage
from covid_deaths
--where location like '%states'
order by 1,2

---to find highest infection count

select location,population,max(total_cases) as highest_infection_count,max(total_cases/population)*100 as covidpercentage
from covid_deaths
group by location,population
order by covidpercentage desc

---to find infection count in united states
select location,population,max(total_cases) as highest_infection_count,max(total_cases/population)*100 as covidpercentage
from covid_deaths
where location='united states'
group by location,population



---to find the diff data values in location column

select distinct location
from covid_deaths

---to delete multiple records from location column 
delete
from covid_deaths
where location in ('World','Low income','High income','Upper middle income')

---to find highest death count

select location,max(total_deaths) as totaldeathcount
from covid_deaths
where continent is not null
group by location
order by totaldeathcount desc

---to find death count by continent

select continent,max(total_deaths) as totaldeathcount
from covid_deaths
where continent is not null
group by continent
order by totaldeathcount desc

--to find sum of new cases and new deaths
select date,sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,sum(new_deaths)/nullif(sum(new_cases),0)*100 as deathpercentage
from covid_deaths
where continent is not null
group by date
order by 1,2

---to join two tables
select *
from covid_deaths dea
join covid_vaccinations vac
on dea.location=vac.location
and dea.date=vac.date

---total population vs vaccinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as totalvaccinatedpeople
from covid_deaths dea
join covid_vaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

---using With clause
with popvsvac(continent,location,date,population,new_vaccinations,totalvaccinatedpeople)
as(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as totalvaccinatedpeople
From covid_deaths dea
join covid_vaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
)
select*,(totalvaccinatedpeople/population)*100
from popvsvac

--to create temp table
drop table if exists vaccinatedpeoplepercentage
create table vaccinatedpeoplepercentage
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
totalvaccinatedpeople numeric
)
insert into vaccinatedpeoplepercentage
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as totalvaccinatedpeople
From covid_deaths dea
join covid_vaccinations vac
on dea.location=vac.location
and dea.date=vac.date
select*,(totalvaccinatedpeople/population)*100 as vaccinationpercentage
from vaccinatedpeoplepercentage

---to create view

create view vvaccinatedpeoplepercentage as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as totalvaccinatedpeople
From covid_deaths dea
join covid_vaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

