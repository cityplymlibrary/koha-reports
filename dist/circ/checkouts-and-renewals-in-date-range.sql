SELECT  borrowers.cardnumber,borrowers.surname,borrowers.firstname,statistics.datetime,statistics.type,items.barcode,items.itype
FROM borrowers
LEFT JOIN statistics on (statistics.borrowernumber=borrowers.borrowernumber)
LEFT JOIN items on (items.itemnumber = statistics.itemnumber)
LEFT JOIN biblioitems on (biblioitems.biblioitemnumber = items.biblioitemnumber)
WHERE statistics.datetime BETWEEN <<Checked out BETWEEN (yyyy-mm-dd)|date>> 
AND <<and (yyyy-mm-dd)|date>> AND statistics.type IN ('issue','renew')
