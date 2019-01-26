libname company "C:\Users\dkewon\Documents\GitHub\BusinessReportingTools\Extra_dataset";
*1)	Which sales agent made the most sales in 2009?;
PROC SQL;
	SELECT e.EmployeeId, e.firstname, e.lastname, MAX(D.total_sales) as max_sales
	FROM company.Employees as e, (SELECT B.SupportRepId, SUM(C.Total) as total_sales
								FROM company.Customers as B, company.Invoices as C
								WHERE B.CustomerId = C.CustomerId
								AND (year(datepart(InvoiceDate))) = 2009
								GROUP BY B.SupportRepId)as D
			WHERE e.EmployeeId = D.SupportRepId
			HAVING max_sales = D.total_sales;
quit;

*2)	Provide a query that shows the top 5 most purchased songs. (using the obsout option);
*max 5 rows;
PROC SQL outobs = 5;
	SELECT A.TrackId, A.Name, SUM(B.Quantity) as number_purchase
	FROM company.Tracks as A, company.Invoice_Items as B
	WHERE A.TrackId = B.TrackId 
	GROUP BY A.TrackId, A.Name
	ORDER BY number_purchase DESC ;
quit;

*3)	Display the maximum amount spent for US customers, and for non-US customers;
PROC SQL;
	SELECT cat('US customers'), MAX(D.total_sales) as max_spent, D.CustomerId
	FROM (SELECT B.CustomerId, SUM(C.Total) as total_sales
								FROM company.Customers as B, company.Invoices as C
								WHERE B.CustomerId = C.CustomerId
								AND B.Country = 'USA'
								GROUP BY B.CustomerId)as D
		HAVING max_spent = D.total_sales
	Union

	SELECT cat('non-US customers') as label,MAX(D.total_sales) as max_spent, D.CustomerId
	FROM (SELECT B.CustomerId, SUM(C.Total) as total_sales
								FROM company.Customers as B, company.Invoices as C
								WHERE B.CustomerId = C.CustomerId
								AND B.Country <> 'USA'
								GROUP BY B.CustomerId)as D
		HAVING max_spent = D.total_sales;
quit;

*4)	Which country’s customers spent the most? ;
PROC SQL;
	SELECT D.Country, MAX(D.total_sales) as max_sales
	FROM (SELECT B.Country, SUM(C.Total) as total_sales
								FROM company.Customers as B, company.Invoices as C
								WHERE B.CustomerId = C.CustomerId
								GROUP BY B.Country)as D
			HAVING max_sales = D.total_sales;
quit;
*5)	Select the customers that spent at least 80% of the maximum amount spent by one customer. Give the customer ids and amount spent;
PROC SQL;
	SELECT B.CustomerId, SUM(C.Total) as eightyspent
	FROM company.Customers B, company.Invoices C, (SELECT MAX(D.total_sales)*0.80 as max_spent
														FROM (SELECT B.CustomerId, SUM(C.Total) as total_sales
																FROM company.Customers as B, company.Invoices as C
																WHERE B.CustomerId = C.CustomerId
																GROUP BY B.CustomerId)D) E
	WHERE B.CustomerId = C.CustomerId
	GROUP BY B.CustomerId
	HAVING eightyspent >= E.max_spent
	ORDER BY eightyspent DESC;
quit;

*6)	Display the name (Firstname lastname) and age of the employees older than the General Manager. ;
PROC SQL;
	SELECT A.FirstName, A.LastName,DATEDIFF(YY, BirthDate, GetDate()) / 365.25 as age
	FROM company.Employees A
	WHERE Datepart(A.BirthDate) < (SELECT Datepart(B.BirthDate)
								FROM company.Employees as B
								WHERE B.Title = 'General Manager');
quit;

*7)	Give the list of tracks from Alanis Morissette that sold better (= more items) than the best Aerosmith’s tracks. ;
*No rows were selected;

PROC SQL;
SELECT B.TrackId, C.Name, SUM(B.Quantity) as total_sales_Alanis
	FROM company.invoice_items B, company.tracks C, company.albums D, company.artists E
	WHERE B.TrackId = C.TrackId
		AND C.AlbumId = D.AlbumId
		AND D.ArtistId = E.ArtistId
		AND E.Name = 'Alanis Morissette'
	GROUP BY B.TrackId
	HAVING total_sales_Alanis > (SELECT MAX(F.total_sold_Aerosmith) as max_sales_Aerosmith
		FROM (SELECT SUM(B.Quantity) as total_sold_Aerosmith
				FROM company.invoice_items B, company.tracks C, company.albums D, company.artists E
				WHERE B.TrackId = C.TrackId
						AND C.AlbumId = D.AlbumId
						AND D.ArtistId = E.ArtistId
						AND E.Name = 'Aerosmith'
				GROUP BY B.TrackId) F);
quit;

*8)	Select all track ids for the tracks that are shorter than the tracks where the composer’s name starts with an “a”. ;
PROC SQL;
	SELECT B.TrackId, C.Milliseconds
	FROM company.invoice_items B, company.tracks C, company.albums D, company.artists E
	WHERE B.TrackId = C.TrackId
		AND C.AlbumId = D.AlbumId
		AND D.ArtistId = E.ArtistId
		AND C.Milliseconds < (SELECT MIN(C.Milliseconds) as min_milliseconds
								FROM company.invoice_items B, company.tracks C, company.albums D, company.artists E
								WHERE B.TrackId = C.TrackId
										AND C.AlbumId = D.AlbumId
										AND D.ArtistId = E.ArtistId
										AND E.Name LIKE 'A%');

quit;
