libname artists "C:\Users\dkewon\Documents\GitHub\BusinessReportingTools\Extra_dataset";
*1)	Give the description and number sold for all tracks that the customers served by employee number 3 have ever purchased;

PROC SQL;
	SELECT t.TrackId, t.Name, c.SupportRepId, SUM(ii.Quantity) as total_sold
	FROM artists.customers c, artists.invoices i, artists.invoice_items as ii, artists.tracks as t	
	WHERE c.CustomerId = i.CustomerId AND i.InvoiceId = ii.InvoiceId AND ii.TrackId = t.TrackId AND c.SupportRepId = 3		
	GROUP BY t.TrackId;				
Quit;

 *2)	Give the genres (in text) that are sold most (more than 100 times).;
proc sql;
select
       g.name,
	   sum(quantity) as most_sold

   from artists.genres as g,
        artists.tracks as t,
		artists.invoice_items as i

   where g.genreID = t.genreID and i.trackid = t.trackid 
   group by g.genreid,g.name
   having most_sold>100
   order by most_sold desc;
quit;

*3)	Give a list of the employees (employee nbr, firstname and lastname) with their total sales & order by sales (descending). Only take into account US customers and have sold more than 150 $. ;
proc sql;
select distinct e.lastname,
       e.firstname,
	   e.employeeid,
	   sum(i.total) as total_sales,
	   c.country
from 
artists.customers as c,
artists.employees as e,
artists.invoices as i
where e.employeeid = c.supportrepid and c.customerid=i.customerid and c.Country in ('USA')
group by e.employeeid
having total_sales > 150
order by total_sales desc;
quit;

*4)	Give a list of the supervisors (employee nbr, firstname and lastname) with the total sales of their employees & order by sales. Do this only for the most recent customers (customernr > 25);
proc sql;
select distinct e.employeeid,ee.employeeid as supervisorid,e.firstname,e.lastname,sum(i.total) as total_sales

from artists.employees as e,
artists.customers as c,
artists.invoices as i,
artists.employees as ee

WHERE e.employeeid = c.supportrepid and c.customerid=i.customerid and e.employeeid = input(ee.reportsto)
and c.customerid >25
group by e.employeeid, ee.employeeid, e.firstname, e.lastname
order by total_sales desc;
quit;

*5)	List the different genres (in text) in playlists that start with ‘Classical’.; 
PROC SQL;
SELECT distinct p.PlaylistId,g.Name
FROM artists.genres as g, artists.tracks as t, artists.playlist_track as pt, artists.playlists as p
WHERE g.genreid = t.genreid and t.trackid = pt.trackid and pt.playlistid = p.playlistid and p.Name LIKE '%Classical%'
order by g.name;
QUIT; 

*6)	Display the playlists that do contain rock tracks, but not pop tracks.; 
*Apparent invocation of macro not resolved?;
%let name=rock;
%let nametwo=pop;

proc sql;
SELECT distinct p.name
FROM artists.tracks as t,
	 artists.genres as g,
	 artists.playlist_track as pt,
	 artists.playlists as p

WHERE t.genreid = g.genreid and t.trackid=pt.trackid and pt.playlistid = p.playlistid and g.name like '%'||"&name"||'%'
and g.name not like '%'||"&nametwo"||'%'
order by g.name;
run;


*7)	Give a list of employees (employeeid, name and city) , together with the number of customers they are serving (only the ones who are serving customers should be included); 
proc sql;
select distinct e.employeeid,e.lastname,e.firstname,count(c.customerid)as number
from 
artists.customers as c,
artists.employees as e

where e.employeeid = c.supportrepid 
group by e.employeeid 
order by e.employeeid;
run;


*8)	Give a list that contains the artists names bought by both customerID 1 and 2; 
proc sql;
select ar.name
from 
artists.invoice_items as ii,
artists.invoices as i,
artists.tracks as t,
artists.albums as al,
artists.artists as ar
where i.customerid = 1 and i.invoiceid = ii.invoiceid and ii.trackid = t.trackid and al.albumid = t.albumid 
and al.artistid=ar.artistid 

intersect 
select ar.name
from 
artists.invoice_items as ii,
artists.invoices as i,
artists.tracks as t,
artists.albums as al,
artists.artists as ar
where i.customerid = 2 and i.invoiceid = ii.invoiceid and ii.trackid = t.trackid and al.albumid = t.albumid 
and al.artistid=ar.artistid;

quit;


*9)	Give all the tracks with their sales. Each track should be shown, whether or not they have sales.;  
proc sql;
select distinct ii.trackid, sum(ii.unitprice) as sales, t.name
from artists.invoice_items as ii, artists.tracks as t
where ii.trackid = t.trackid
group by ii.trackid;
quit;

*10)	Give media type names of all tracks that generated more than 1$ in sales and that were also purchased by customer with customerID 33.; 
proc sql;
select distinct m.name, sum(i.total) as total_sales
from artists.invoices as i, artists.invoice_items as ii, artists. tracks as t, artists.media_types as m
where i.invoiceid = ii.invoiceid and ii.trackid=t.trackid and t.mediatypeid = m.mediatypeid and i.customerid = 33
group by m.name
having total_sales > 1
order by total_sales desc;
quit;
 
