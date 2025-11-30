create database  projects;
use projects;
select * from consum_3;
select * from country_3;
select * from emmission_3;
select * from gdp_3;
select * from population_3;
select * from production_3;

select country,energy_type,emission from emmission_3
order by emission desc;
select distinct(energy_type) from emmission_3;
-- ANALYSIS questions

-- General & Comparative Analysis
-- Q1. What is the total emission per country for the most recent year available?
select e.country,e.eyear,sum(e.emission) as Total_emission from emmission_3 e
where eyear= (select max(eyear) from emmission_3)
group by e.country,e.eyear
order by e.eyear;



-- Q2.What are the top 5 countries by GDP in the most recent year?
select Country ,value as Total_value from gdp_3 
where year= (select max(year) from gdp_3)
order by Total_value desc limit 5;

-- Q3.Compare energy production and consumption by country and year.
select p.country,p.year,sum(p.production) as  Energy_Production ,
sum(c.consumption)  as Energy_consumption from production_3 p
 join consum_3 c on
p.country = c.country and
p.year = c.year
group by p.country,p.year
order by p.country,p.year;
-- Q4.Which energy types contribute most to emissions across all countries?
select energy_type,sum(emission) as Total_Emissions from emmission_3
group by energy_type
order by  Total_Emissions desc ;

 select energy type from emission_3;
 -- TREND ANALYSIS OVER TIME
 -- Q5.How have global emissions changed year over year?
 select eyear,sum(emission) as Total_Emissions from emmission_3 
 group by eyear
 order by eyear;
 
 -- Q6.What is the trend in GDP for each country over the given years?
 select Country,value,year  from gdp_3  order by Country,year desc;
 
 -- Q7.How has population growth affected total emissions in each country?
 select p.countries,p.year,p.value as Polpulation ,sum(e.emission ) as Total_Emissions 
 from population_3 p
 join emmission_3 e on
 e.country =p.countries and
 e.eyear= p.year
 group by p.countries,p.year,p.value
 order by p.countries,p.year;
 
 
 -- Q8. Has energy consumption increased or decreased over the years for major economies?
 select c.country,c.year,sum(c.consumption) as Total_Consumption
 from consum_3 c
 join (select country from gdp_3
 where year =(select max(year) from gdp_3)
 order by value desc
 limit 5
) top_countries on c.country = top_countries.country
group by c.country ,c.year
order by c.country ,c.year; 

 -- Q9.What is the average yearly change in emissions per capita for each country?
 select country,eyear,per_capita_emission,
per_capita_emission - lag (per_capita_emission) over
(partition by country order by eyear) as yearly_change
from emmission_3 
order by country,eyear desc;

 
 
 -- Ratio & Per Capita Analysis
 
 -- Q10.What is the emission-to-GDP ratio for each country by year?
select e.country,e.eyear,sum(emission)/sum(value) as Emission_to_GDP_Ratio from emmission_3 e
join gdp_3 g on
e.country =g.country and
e.eyear =g.year
group by e.eyear,e.country
order by e.eyear,e.country;


 -- Q11.What is the energy consumption per capita for each country over the last decade?
select p.countries,c.year,sum(c.consumption)/sum(p.value) as Energy_consumption_per_capita 
 from consum_3 c
join population_3 p on
c.country=p.countries and
c.year =p.year  
where c.year >= (select max(year) from consum_3) -10
group by p.countries,c.year
order by Energy_consumption_per_capita asc limit 10;
-- Q12.How does energy production per capita vary across countries? 
select pro.country,pro.year,sum(pro.production)/sum(p.value) as Production_per_capita
 from production_3 pro
join population_3 p on
pro.country=p.countries and pro.year =p.year
group by pro.country,pro.year
order by pro.country,pro.year;

-- Q13.Which countries have the highest energy consumption relative to GDP? 
select c.country,c.year,
sum(c.consumption)/sum(g.value) as Consumption_to_GDP_Ratio
from consum_3 c
join gdp_3 g
on c.country =g.country and c.year =g.year
group by c.country, c.year
order by Consumption_to_GDP_Ratio desc;



-- GLOBAL COMPARISONS
-- Q14.What are the top 10 countries by population and how do their emissions compare? 
select p.year,p.countries,sum(p.value) as Population,sum(e.emission) as Emission from population_3 p
join emmission_3 e on 
e.country =p.countries 
group by p.countries ,p.year
order by population desc limit 10;


 
-- Q15. What is the global share (%) of emissions by country?
select e.country,
(sum(e.emission)/(select sum(emission) from emmission_3)*100) as Global_Share_Percent
from emmission_3 e
group by e.country
order by Global_Share_Percent desc;

-- Q16.What is the global average GDP, emission, and population by year?
select p.year,avg(g.value) as avg_gdp,
              avg(e.emission) as avg_emission,
              avg(p.value) as avg_population
from gdp_3 g
join emmission_3 e on 
g.year=e.eyear and g.country = e.country
join population_3 p on
e.eyear= p.year and e.country =p.countries
group by p.year
order by p.yearcountry_3;