SELECT DATE_FORMAT(reserves.reservedate, '%d/%m/%Y') AS 'Date',
	CONCAT('<a href="https://ccp-staff.koha-ptfs.co.uk/cgi-bin/koha/circ/circulation.pl?borrowernumber=', borrowers.borrowernumber, '#reserves">', borrowers.firstname, ' ', borrowers.surname, '<br />', '(', borrowers.cardnumber, ')' '</a>') AS 'Patron',
	CONCAT('<a href="https://ccp-staff.koha-ptfs.co.uk/cgi-bin/koha/catalogue/detail.pl?biblionumber=', biblio.biblionumber, '">', biblio.title, '</a>', '<br />', '<strong>', biblio.author, '</strong>', '<br />', ExtractValue(biblio_metadata.metadata, '//datafield[@tag="260"]/subfield[@code="b"]'), ', ', SUBSTR(ExtractValue(biblio_metadata.metadata,'//controlfield[@tag="008"]'),8,4), '<br />', 'ISBN: ', biblioitems.isbn) AS 'Title',
	ExtractValue(biblio_metadata.metadata, '//datafield[@tag="082"]/subfield[@code="a"]') AS 'Call number',
    reserves.priority as 'Priority',
	CASE WHEN items.barcode IS NULL THEN '<em>Any available item</item>' ELSE items.barcode END AS 'Barcode',
    CONCAT('<a class="btn btn-default" href="https://ccp-staff.koha-ptfs.co.uk/cgi-bin/koha/catalogue/detail.pl?biblionumber=', biblio.biblionumber, '#holdings" target="_blank">Check availability</a') AS 'Item availability',
	CASE WHEN reserves.reservenotes IS NULL THEN 'None recorded' WHEN reserves.reservenotes = '' THEN 'None recorded' ELSE reserves.reservenotes END AS 'Notes'
FROM reserves
LEFT JOIN borrowers USING (borrowernumber)
LEFT JOIN biblio USING (biblionumber)
LEFT JOIN biblio_metadata USING (biblionumber)
LEFT JOIN biblioitems USING (biblionumber)
LEFT JOIN items USING (itemnumber)
ORDER BY reserves.reservedate ASC, 
	borrowers.surname ASC
