# Select all columns

select * from project.dataset1;
select * from project.dataset2;

# Number of rown in dataset

select count(*) from project.dataset1;
select count(*) from project.dataset2;

# Dataset for jharkhand and bihar

select * from project.dataset1
where state in ('Jharkhand', 'Bihar')

# Total population of India

select sum(population)  total_pop from project.dataset2;

# Average growth of country

select avg(growth)*100 avg_growth from project.dataset1

# Average growth state-wise and arrange in desc

select state,avg(growth)*100 avg_growth from project.dataset1
group by state order by avg_growth desc

# Avg sex ratio state-wise and arrange in desc

select state,round(avg(sex_ratio)*100) avg_sexratio from project.dataset1
group by state order by avg_sexratio desc

# State having avg literacy rate >80 

select state, round(avg(literacy),0) avg_literacyrate from project.dataset1
group by state 
having avg_literacyrate >80
order by avg_literacyrate desc

# Top 3 states showing highest growth ratio 

select state,avg(growth)*100 avg_growth from project.dataset1
group by state order by avg_growth desc
limit 3

# Top 3 states showing highest avg growth ratio using dense_rank function

select * from(select *, dense_rank() over (order by avg_growth desc) growth_rank from
(select state, (avg(growth)*100) avg_growth from project.dataset1
group by state order by avg_growth desc) as a) as b
where  growth_rank in (1,2,3)

# Bottom 3 states showing lowest avg growth ratio using dense_rank function

select * from(select *, dense_rank() over (order by avg_growth asc) growth_rank from
(select state, (avg(growth)*100) avg_growth from project.dataset1
group by state order by avg_growth asc) as a) as b
where  growth_rank in (1,2,3)

# Showing top 3 and bottom 3 states in avg_growth

select * from(select *, dense_rank() over (order by avg_growth desc) growth_rank from
(select state, (avg(growth)*100) avg_growth from project.dataset1
group by state order by avg_growth desc) as a) as b
where  growth_rank in (1,2,3)
union
select * from(select *, dense_rank() over (order by avg_growth asc) growth_rank from
(select state, (avg(growth)*100) avg_growth from project.dataset1
group by state order by avg_growth asc) as a) as b
where  growth_rank in (1,2,3)

# States starting with letter 'a' or 'b'

select distinct state from project.dataset1 where state like 'A%' or state like 'B%'

# State start with letter 'a' but end with 'm'

select distinct state from project.dataset1 where state like 'A%' and state like '%m'

# Joining two tables and find total males and females
 
select state, sum(males) total_males, sum(female) total_female from
(select district, state,round( population/(sratio+1),0) males ,round( population*sratio/(sratio+1)) female from
(Select a.district,a.state,a.sex_ratio/1000 as sratio,ifnull(population,0) as population from 
project.dataset1 a inner join project.dataset2 b
on a.district = b.district) as f) s group by state

#Total literate and illeterate people state wise

select c.state state ,sum(round(literacy_ratio*population/100,0)) total_literatepeople,
sum(round((100-literacy_ratio)*population/100,0)) total_illiteratepeople
from
(Select a.district,a.state,a.literacy as literacy_ratio,ifnull(population,0) as population from 
project.dataset1 a inner join project.dataset2 b
on a.district = b.district) as c
group by state
order by state asc

# Population in previous census and current census

select district,state,round((population-population*growth_ratio/100),0) previous_population, population current_population
from
(Select a.district,a.state,round(a.growth*100,0) as growth_ratio,ifnull(population,0) as population from 
project.dataset1 a inner join project.dataset2 b
on a.district = b.district) as z

#Total population of India in both the census

select sum(previous_population) Previous_pop_total,sum(current_population) Current_pop_total 
from
(select district,state,round((population-population*growth_ratio/100),0) previous_population, population current_population
from
(Select a.district,a.state,round(a.growth*100,0) as growth_ratio,ifnull(population,0) as population from 
project.dataset1 a inner join project.dataset2 b
on a.district = b.district) as z) as m

# Top 3 district of each state having highest literacy ratio using dense rank

select a.state,a.district,a.literacy from
(select * , dense_rank() over (partition by state order by literacy desc) ranking
from project.dataset1) as a
where ranking in(1,2,3)








 