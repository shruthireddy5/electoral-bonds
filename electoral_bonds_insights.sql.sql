-- Questions On Electoral Bonds
USE electoralbonddata;
show tables;

select  *
from donordata;
select  *
from bonddata;
select * from receiverdata;
-- 1. Find out how much donors spent on bonds
select sum(denomination) as total
from donordata d
join bonddata b
on d.unique_key=b.unique_key;

-- 2. Find out total fund politicians got
SELECT SUM(Denomination) as fund_Amount
FROM receiverdata r 
JOIN bonddata b 
on r.Unique_key = b.Unique_key;
-- 3. Find out the total amount of unaccounted money received by parties
select * from receiverdata;
select * from bonddata;
select r.partyname,sum(denomination) as total_amount
from donordata d
right join receiverdata r on r.unique_key=d.unique_key
join bonddata b
on r.unique_key=b.unique_key
where d.purchaser is null
group by r.partyname;
 
-- 4.Find year wise how much money is spend on bonds
select year(d.purchasedate) as year,sum(denomination)
from donordata d
join bonddata b
on b.unique_key=d.unique_key
group by year
order by year desc;

 -- 5. In which month most amount is spent on bonds
 select monthname(purchasedate) as month ,sum(denomination) as total
 from donordata d
 join bonddata b
 on b.unique_key=d.unique_key
 group by month
 order by total desc limit 1;
 -- 6. Find out which company bought the highest number of bonds.
 select d.purchaser as company_bought ,count(b.unique_key) as highest_bonds
 from bonddata b
 join donordata d
 on d.unique_key=b.unique_key
 group by company_bought
 order by highest_bonds  desc limit 1;
 
 -- 7. Find out which company spent the most on electoral bonds.
 select d.purchaser as company_spent , sum(denomination) as total
 from bonddata b
 join donordata d
 on d.unique_key=b.unique_key
 group by company_spent
 order by total desc limit 1;
 
 
--  8. List companies which paid the least to political parties.
WITH min_donors AS (
    SELECT d.purchaser as purchaser,sum(denomination) AS least_amount
    FROM donordata d
    join bonddata b
    on b.unique_key=d.unique_key
    group by purchaser
)
SELECT purchaser , least_amount
FROM min_donors
WHERE least_amount = (SELECT min(least_amount) FROM min_donors);

 -- 9. Which political party received the highest cash?
 select r.partyname,sum(denomination) as highest_cash
 from bonddata b
 join receiverdata r
 on r.unique_key=b.unique_key
 group by r.partyname
 order by highest_cash desc limit 1;
 
  
 -- 10. Which political party received the highest number of electoral bonds?
 select r.partyname,count(denomination) as no_of_electoral_bonds
 from bonddata b
 join receiverdata r
 on r.unique_key=b.unique_key
 group by r.partyname
 order by no_of_electoral_bonds desc limit 1;
 
 
 -- 11. Which political party received the least cash?
 select r.partyname,sum(denomination) as least_cash
 from bonddata b
 join receiverdata r
 on r.unique_key=b.unique_key
 group by r.partyname
 order by least_cash  limit 1;
 
 
 -- 12. Which political party received the least number of electoral bonds?
 select r.partyname,count(denomination) as no_of_least_electoral_bonds
 from bonddata b
 join receiverdata r
 on r.unique_key=b.unique_key
 group by r.partyname
 order by no_of_least_electoral_bonds  limit 1;
 
 
-- 13. Find the 2nd highest donor in terms of amount he paid?-----*************----------
select d.purchaser,MAX(denomination) as highest_paid
from bonddata b
join donordata d
on d.unique_key=b.unique_key
WHERE denomination < (select max(denomination) from bonddata b)
group by purchaser
order by highest_paid desc limit 1;

 -- 14. Find the party which received the second highest donations?
 select r.partyname,sum(denomination) as second_highest
 from bonddata b
 join receiverdata r
 on r.unique_key=b.unique_key
 where  denomination < (select distinct max(denomination) as highest
 from bonddata b
 join receiverdata r
 on r.unique_key=b.unique_key)
 group by partyname
 order by second_highest desc ;

 
 -- 15. Find the party which received the second highest number of bonds?
 select r.partyname,count(b.unique_key) as second_bond 
 from bonddata b
 join receiverdata r
 on r.unique_key=b.unique_key
 group by partyname
 order by second_bond desc limit 2;

 -- 16. In which city were the most number of bonds purchased?
 select b.city,count(purchaser) as number_of_bonds_purchased
 from bankdata b
 join donordata d 
 on d.paybranchcode= b.branchcodeno
 group by b.city
 order by number_of_bonds_purchased desc limit 1;
 

 -- 17. In which city was the highest amount spent on electoral bonds?
select b.city,sum(denomination) as highest_amount
from bankdata b
join donordata d on d.paybranchcode= b.branchcodeno
join bonddata bd on bd.unique_key=d.unique_key
group by b.city
order by highest_amount desc limit 1;
 
 
 -- 18. In which city were the least number of bonds purchased?
 select b.city,count(denomination) as least_no_of_bonds
from bankdata b
join donordata d on d.paybranchcode= b.branchcodeno
join bonddata bd on bd.unique_key=d.unique_key
group by b.city
order by least_no_of_bonds limit 1;

 -- 19. In which city were the most number of bonds enchased?
 select b.city,count(r.unique_key) as most_no_of_bonds
 from bankdata b
 join receiverdata r
 on r.paybranchcode=b.branchcodeno
 group by b.city
 order by most_no_of_bonds desc limit 1;
 
 -- 20. In which city were the least number of bonds enchased?
                                                                
 select b.city,count(r.unique_key) as least_no_of_bonds
 from bankdata b
 join receiverdata r
 on r.paybranchcode=b.branchcodeno
 group by b.city
 order by least_no_of_bonds limit 1;

 
 -- 21. List the branches where no electoral bonds were bought; if none, mention it as null.
select b.Address as list_branches
from bankdata b 
left join donordata d
on b.branchCodeNo=d.PayBranchCode
where d.PayBranchCode is null ;

 -- 22. Break down how much money is spent on electoral bonds for each year.
 select year(d.purchasedate) as year,sum(b.denomination) as spent_on_electoralbond
 from bonddata b
 join donordata d
 on d.unique_key=b.unique_key
 group by year
 order by spent_on_electoralbond;

 
 -- 23. Break down how much money is spent on electoral bonds for each year and provide the year and the amount. Provide values for the highest and least year and amount.
 select year(d.purchasedate) as year,sum(b.denomination) as spent_on_electoralbond
 from bonddata b
 join donordata d
 on d.unique_key=b.unique_key
 where denomination=
 (select year(max(d.purchasedate)) as highest_year,year(min(d.purchasedate)) as least_year
 from donordata);
 
 -- 24. Find out how many donors bought the bonds but did not donate to any political party?
 SELECT COUNT(*) 
FROM donordata d
left JOIN receiverdata r ON r.Unique_key = d.Unique_key
WHERE r.partyname is NULL;

 -- 25. Find out the money that could have gone to the PM Office, assuming the above question assumption (Domain Knowledge)
 SELECT SUM(Denomination)
FROM donordata d
LEFT JOIN receiverdata r ON r.Unique_key = d.Unique_key
JOIN bonddata b ON b.Unique_key = d.Unique_key
WHERE partyname is NULL;

 -- 26. Find out how many bonds don't have donors associated with them.
 SELECT COUNT(*) 
FROM donordata d
RIGHT JOIN receiverdata r ON r.Unique_key = d.Unique_key
WHERE purchaser is NULL;

 -- 27. Pay Teller is the employee ID who either created the bond or redeemed it. So find the employee ID who issued the highest number of bonds.
 select d.payteller as employee_id,count(b.denomination) as no_of_bonds
 from bonddata b
 join donordata d
 on d.unique_key=b.unique_key
 group by employee_id
 order by no_of_bonds desc limit 1;

 -- 28. Find the employee ID who issued the least number of bonds.
  select d.payteller as employee_id,count(b.denomination) as least_no_of_bonds
 from bonddata b
 join donordata d
 on d.unique_key=b.unique_key
 group by employee_id
 order by least_no_of_bonds limit 1;
                                
 -- 29. Find the employee ID who assisted in redeeming or enchasing bonds the most.
 select payteller as employee_id,sum(dateencashment) as most_enchasing_bonds
 from receiverdata
 group by employee_id
 order by most_enchasing_bonds desc limit 1;
 
 -- 30. Find the employee ID who assisted in redeeming or enchasing bonds the least

select payteller as employee_id,sum(dateencashment) as least_enchasing_bonds
 from receiverdata
 group by employee_id
 order by least_enchasing_bonds limit 1;
 -- Some more Questions you can try answering Once you are done with above questions.
 
 -- 1. Tell me total how many bonds are created?
 
 select count(unique_key)
 from bonddata;
 -- 2. Find the count of Unique Denominations provided by SBI?
 select  count(distinct denomination)
 from bonddata;
 
 -- 3. List all the unique denominations that are available?
 select distinct denomination
 from bonddata;
-- 4. Total money received by the bank for selling bonds
select sum(denomination)
from bonddata;
 -- 5. Find the count of bonds for each denominations that are created.
 select distinct denomination, count(denomination) as count_bonds
 from  bonddata
 group by  denomination
 order by denomination;
 -- 6. Find the count and Amount or Valuation of electoral bonds for each denominations.
 select denomination,count(denomination) as count,sum(denomination) as amount
 from bonddata
 group by denomination
 order by amount;
 -- 7. Number of unique bank branches where we can buy electoral bond?
 select count( branchcodeno)
 from bankdata;
 -- 8. How many companies bought electoral bonds
 select count(distinct purchaser)
 from donordata;
 
 
 -- 9. How many companies made political donations
 select distinct count(purchaser) from donordata;
 -- 10. How many number of parties received donations
 select count(distinct partyname)
 from receiverdata;
 -- 11. List all the political parties that received donations
 select distinct partyname
 from receiverdata;
 -- 12. What is the average amount that each political party received
 select r.partyname,avg(b.denomination) as avg_amount
 from bonddata b
 join receiverdata r
 on r.unique_key=b.unique_key
 group by partyname;
 
 -- 13. What is the average bond value produced by bank
 select avg(denomination)
 from bonddata;
 -- 14. List the political parties which have enchased bonds in different cities?
 select  distinct r.partyname, b.city
 from bankdata b
 join receiverdata r
 on r.paybranchcode=b.branchcodeno;

 -- 15. List the political parties which have enchased bonds in different cities and list the cities in which the bonds have enchased as well
 select distinct r.PartyName, b.city
 from receiverdata r 
 join bankdata b
on r.PayBranchCode=b.branchCodeNo
group by partyname,city;
