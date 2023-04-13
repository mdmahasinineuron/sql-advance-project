/* This Script include some questions based on the "Music_Store_database"
to fincd insight from the the data bases*/

/*Q(1) 1. Who is the most senior employee based on their job title.
	answear-> Modan Mohan empolyee_id 9 level l7*/

SELECT empolyee_id, first_name,last_name, title FROM employee
ORDER BY level DESC
    /*ANS- 9 Modan Mohan L7

/* Q(2) 2. Which country have the most invoices?*/

	SELECT billing_country, 	COUNT(billing_country) AS 	frequency_of_billing
	FROM invoice GROUP BY billing_country
	ORDER BY frequency_of_billing DESC
	LIMIT 5

/*Q(3) 3. What are top 3 values of total invoices*/

SELECT * from invoice
ORDER BY total
DESC
LIMIT 3

    /* result */
/*183	42	"2018-02-09 00:00:00"	"9, Place Louis Barthou"	"Bordeaux"	"None"	    "France"	"33000"	    23.759999999999998
    92	32	"2017-07-02 00:00:00"	"696 Osborne Street"		"Winnipeg"	"MB"		"Canada"	"R3L 2B9"	19.8
    31	3	"2017-02-21 00:00:00"	"1498 rue Bélanger"		    "Montréal"	"QC"		"Canada"	"H2G 1A7"	19.8 */


/*4. Which city has the best customers we would like to throw a promotion on music festivals in 
the city we made the most money wrirte a query that returns one city that has the highest sum
 of invoices totals?*/

SELECT billing_city, SUM(total) AS total_sum_of_inv from invoice
GROUP BY billing_city
ORDER BY total_sum_of_inv DESC
LIMIT 1

/*ANS
"Prague"	273.24000000000007*/

/*5. Who is the best customer? The customer who spend the most money*/

	SELECT customer.first_name, customer.last_name, customer.customer_id,
sum(invoice.total) AS total_spend
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spend DESC
LIMIT 1

/*ANS*/
"R"	"Madhav"	5	144.54000000000002

/*6) Give all the custimer email, first name and last name and cutomer
    id who buyed genre of rock order by email starts A	- Z*/

SELECT DISTINCT email, first_name, last_name FROM(SELECT DISTINCT email,
						   first_name, last_name,
						   invoice.invoice_id FROM customer
						   JOIN invoice
						   ON customer.customer_id = invoice.customer_id
						   JOIN invoice_line
						   ON invoice_line.invoice_id = invoice.invoice_id
						   WHERE track_id IN(SELECT track_id FROM track
											 JOIN genre
											 ON track.genre_id = genre.genre_id
											 WHERE genre.name LIKE 'Rock')
						   ORDER BY email ASC) SUB

/*7) Give  the  top 10 artist name who sang most song belongs to the rock genre*/


SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) as no_of_song
FROM track
JOIN album
ON album.album_id = track.album_id
JOIN artist
ON artist.artist_id = album.artist_id
JOIN genre
ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY no_of_song DESC
LIMIT 10


/*8) We want to know best genre for each country*/
	genre which make the most sell is to be called best genre
	WITH making_table AS(
					SELECT invoice.billing_country,genre.name AS genre_name, SUM(invoice.total) AS country_wise_total from invoice
					JOIN invoice_line
					ON invoice.invoice_id = invoice_line.invoice_id
					JOIN track
					ON invoice_line.track_id = track.track_id
					JOIN genre
					ON track.genre_id = genre.genre_id
					GROUP BY 1, 2
					ORDER BY 1 )

SELECT billing_country, genre_name, country_wise_total FROM making_table
WHERE country_wise_total IN (SELECT MAX(country_wise_total) FROM making_table
							GROUP BY billing_country)
ORDER BY 1
