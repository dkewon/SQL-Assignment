***Chinook dataset : questions session 1;

***(1)Give the number of managers at the company.;
libname artists "C:\Users\dkewon\Documents\GitHub\BusinessReportingTools\Extra_dataset";

PROC SQL;
SELECT COUNT(Title) AS Number_of_Managers
FROM artists.Employees
WHERE Title LIKE '%Manager%';
QUIT; 

PROC SQL;
SELECT EmployeeId,Title
FROM artists.Employees
WHERE Title LIKE '%Manager%';
QUIT; 

***(2)Give the number of (unique) artists who have an album with a second disc in it (“Disc 2”);

PROC SQL;
SELECT COUNT(Distinct ArtistId) AS Number_of_Artists
FROM artists.Albums
WHERE Title LIKE '%Disc 2%';
QUIT; 
PROC SQL;
SELECT Distinct ArtistId,Title
FROM artists.Albums
WHERE Title LIKE '%Disc 2%';
QUIT; 

***(3)Display the average number of tracks purchased per invoice?;
PROC SQL;
SELECT count(trackId)/count(distinct InvoiceId) as Number_of_tracks_per_invoice
FROM artists.Invoice_items;
QUIT; 
PROC SQL;
SELECT InvoiceId, count(trackId) as Number_of_tracks_per_invoice
FROM artists.Invoice_items
group by InvoiceId;
QUIT; 

***(4)Give the number of customers per country where the postal code is not “NA” and order by country;
PROC SQL;
SELECT Country,count(customerId) as Number_of_customers_per_country
FROM artists.Customers
Where PostalCode <> 'NA'
group by Country
order by Country;
QUIT; 
PROC SQL;
SELECT Country,customerId 
FROM artists.Customers
Where PostalCode <> 'NA'
group by Country
ORDER BY Country;
QUIT; 
***(5)Show the total amount invoiced;
PROC SQL;
SELECT sum(Total)as total_amount_invoiced
FROM artists.Invoices;
QUIT; 

***(6)Show the total amount invoiced, per month and year, sort per month;
PROC SQL;
select sum(Total)as total_amount, Month(datepart(InvoiceDate)) as Month, Year(datepart(InvoiceDate)) as year
FROM artists.Invoices
group by year, month
order by year, month;
QUIT; 

***(7)Show the total number of invoices per customer in April 2009.;
PROC SQL;
select CustomerId,count(InvoiceId)as total_numb_invoices,Year(datepart(InvoiceDate))as year, Month(datepart(InvoiceDate))as Month
FROM artists.Invoices
where Year(datepart(InvoiceDate))=2009 and Month(datepart(InvoiceDate))= 4
group by CustomerID;
QUIT;
***(8)Show the age of the employees if they are more than 25 years old, and also the time since they are working for the company;
PROC SQL;
select int(yrdif(datepart(Birthdate),Today(),'Age')) as age,int(yrdif(datepart(HireDate),Today(),'Age'))as time_of_work, EmployeeID
FROM artists.Employees
where int(yrdif(datepart(Birthdate),Today(),'Age'))>25;
QUIT;

***(9)Select all playlists that start with a ‘b’;
PROC SQL;
SELECT playlistid, name
FROM artists.playlists
WHERE name LIKE 'B%';
QUIT; 
***(10)Select the number of corporate customers per country;
PROC SQL;
SELECT DISTINCT Country,count(company) as Number_of_corps_per_country
FROM artists.Customers
WHERE company <> 'NA'
GROUP BY COUNTRY;
QUIT;
***(11)Display for each invoice, the invoice number, the amount, and the percentage that this amount has contributed to the total amount invoiced.;
PROC SQL;
SELECT Distinct InvoiceID, total/ (SELECT SUM(total) FROM artists.Invoices) as percentage_contributed
FROM artists.Invoices
GROUP BY invoiceid;
QUIT;

