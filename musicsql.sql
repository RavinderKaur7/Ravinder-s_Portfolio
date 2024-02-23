--1) SENIOR EMPLOYEE OF THE COMPANY
select * from employee$
ORDER BY LEVELS DESC
LIMIT 1:

--2) COUNTRY WITH HIGHEST INVOICE
SELECT BILLING_COUNTRY, COUNT(BILLING_COUNTRY) AS HIGHEST_INVOICES FROM invoice$
GROUP BY BILLING_COUNTRY
ORDER BY COUNT(BILLING_COUNTRY) DESC
LIMIT 1:

--3) Top 3 orders
SELECT distinct (total) FROM invoice$
order by total desc
limit 3;

--4) City with customers
select (invoice$.billing_city),count(customer$.customer_id) as total_customers, sum(invoice$.total) as total from invoice$
join customer$ on customer$.customer_id = invoice$.customer_id
group by invoice$.billing_city
order by count(customer$.customer_id) desc
limit 1;

--5) Top customer
select customer$.first_name as customer, sum(invoice$.total) as total from invoice$
join customer$ on customer$.customer_id = invoice$.customer_id
group by (customer$.first_name)
order by sum(invoice$.total) desc
limit 1;

--6)Write a query to return first name,email,last name, genre of all the rock music listeners.
return your list ordered alphabetically by email starting with a.

select distinct customer$.email, customer$.first_name , customer$.last_name ,genre$.name from customer$
join invoice$ on customer$.customer_id = invoice$.customer_id
join invoiceline$ on invoice$.invoice_id = invoiceline$.invoice_id
join track$ on invoiceline$.track_id = track$.track_id
join genre$ on track$.genre_id = genre$.genre_id
where genre$.name ='Rock'
order by customer$.email

--7) Lets invite the artists who have written the most rock music in our dataset. write A 
-- query that returns the artist name and total track count.

select count(track$.track_id), artist$.name, genre$.name from artist$
join album$ on artist$.artist_id = album$.artist_id
join track$ on album$.album_id = track$.album_id
join genre$ on track$.genre_id = genre$.genre_id
where genre$.name ='Rock'
group by genre$.name, artist$.name
order by count(track$.track_id) desc

--8) return all the track names that have a song length longer than the average song lenght
--return the name and milliseconds for each track order by the song lenght with the longest
--song listed first.

select name, milliseconds
from track$
where milliseconds>(select avg(milliseconds) from track$)
order by (milliseconds) desc

--9) how much customers spent on each artist
select customer$.first_name as Customer_name ,artist$.name as Artist_name, 
sum(invoiceline$.quantity*invoiceline$.unit_price) as Amount_Spent from customer$
join invoice$ on customer$.customer_id = invoice$.customer_id
join invoiceline$ on invoice$.invoice_id = invoiceline$.invoice_id
join track$ on invoiceline$.track_id = track$.track_id 
join album$ on track$.album_id =album$.album_id
join artist$ on album$.artist_id = artist$.artist_id
group by artist$.name,customer$.first_name
order by sum(invoice$.total) desc

--10) Number of purchases of genre by country

select invoice$.billing_country as Country, genre$.name as Genre_Name, 
count(invoiceline$.quantity)Purchases from invoice$
join invoiceline$ on invoice$.invoice_id = invoiceline$.invoice_id
join track$ on invoiceline$.track_id = track$.track_id
join genre$ on track$.genre_id = genre$.genre_id
group by invoice$.billing_country,genre$.name
order by invoice$.billing_country asc, count(invoiceline$.quantity) desc


--11) Highest amount spent by customer with country name
select customer$.first_name as Customer_name ,invoice$.billing_country as Country, 
round(sum(invoice$.total),2) as Amount_Spent from customer$
join invoice$ on customer$.customer_id = invoice$.customer_id
join invoiceline$ on invoice$.invoice_id = invoiceline$.invoice_id
join track$ on invoiceline$.track_id = track$.track_id 
join album$ on track$.album_id =album$.album_id
join artist$ on album$.artist_id = artist$.artist_id
group by customer$.first_name,invoice$.billing_country
order by round(sum(invoice$.total),2) desc
