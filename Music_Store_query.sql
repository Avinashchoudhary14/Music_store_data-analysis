/* Q1: Who is the senior most employee based on job title? */

select first_name, last_name, title
from employee
order by levels desc
limit 1;


/* Q2: Which countries have the most Invoices? */

select count(*) as country, billing_country 
from invoice
group by billing_country 
order by country desc;


/* Q3: What are top 3 values of total invoice? */

select total 
from invoice
order by total desc
limit 3;


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city, count(total) as invoice_total
from invoice
group by billing_city
order by invoice_total desc
limit 1;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select customer.customer_id, first_name, last_name, sum(total) as total_spending
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total_spending desc
limit 1;


/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select distinct email, first_name, last_name 
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (
                  select track_id from track
	              join genre on track.genre_id = genre.genre_id    
	              where genre.name like 'Rock')
order by email;
	

/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.artist_id, artist.name, count(artist.artist_id) as num_of_songs
from track
join album on album.album_id = track.album_id
join artist on album.artist_id = artist.artist_id
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by num_of_songs desc
limit 10;


/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name, milliseconds 
from track
where milliseconds > (
select avg(milliseconds) as avg_milliseconds
from track)
order by milliseconds desc;


/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

with best_selling_artist as (
	select artist.artist_id as artist_id, artist.name as artist_name,
	SUM(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc
	limit 1
)
select customer.customer_id, customer.first_name, customer.last_name, best_selling_artist.artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as amount_spent
from invoice
join customer on customer.customer_id = invoice.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join best_selling_artist on best_selling_artist.artist_id = album.artist_id
group by 1,2,3,4
order by 5 desc;



























