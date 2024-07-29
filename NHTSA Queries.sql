use portfolio
;
select*
From complaints
;

-- Purpose of this project is to provide the Federal Government with information that can be used to hold car manufacturing brands accountable for
-- injuries and also to pinpoint major causes of malfunctions. Data is taken from the National Highway Traffic Safety Administration(NHTSA).

-- 1. number of deaths by manufacturer 
select  manufacturer,make,model,sum(numberofDeaths)
From complaints
group by manufacturer,make,model
having sum(numberofDeaths)> 0
order by sum(numberofDeaths) desc

;
-- 2. models with the most injuries 
with cte as(
select manufacturer,sum(numberofinjuries) as numb_injuries ,model,modelYear,
dense_rank() over (partition by manufacturer order by sum(numberofinjuries) desc)as Injuries_rank
From complaints
group by numberofinjuries,manufacturer, model,modelYear
)
Select manufacturer,Injuries_rank ,model,numb_injuries,modelYear
from cte
where Injuries_rank = 1 and numb_injuries not like'0%'
order by numb_injuries desc
limit 5
;

-- 3. Most common component failure
Select count(component)as totalcomponentfailure, component
From recalls
group by component
order by totalcomponentfailure desc
limit 5
;
 
-- 4. Highest percentage of injury per model
with cte as(
select manufacturer,(numberofinjuries/50000)*100 as percent_injuries ,model,modelYear,
dense_rank() over (partition by manufacturer order by numberofinjuries desc)as perc_rank
From complaints
)
Select manufacturer,perc_rank ,model,percent_injuries,modelYear
from cte
where perc_rank = 1 
order by percent_injuries desc
limit 5
;

-- 5. highest avg of injuries by manufactuer
select manufacturer,avg(numberofinjuries/50000)*100 as percent_injuries
From complaints
group by manufacturer
order by percent_injuries desc
limit 5
;

-- 6. Highest malfunctions per manufacturer
select make, cause,count(cause)
From investigations
group by cause,make
order by count(cause) desc
limit 5
;

-- 7. Injuries by Year
select manufacturer, year(str_to_date(dateofincident,'%m/%d/%Y'))
From complaints
;


-- 8. Did injury include fire?
select manufacturer,count(crash)as number_of_injuries,
case 
when Fire = 'False' then 'No'
when Fire = 'True' then 'Yes'
else 'n/a'
end as _fire
From complaints
group by manufacturer,_fire
order by count(crash) desc
limit 50
;






