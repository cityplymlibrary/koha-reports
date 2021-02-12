SELECT DATE_FORMAT(reserves.reservedate, '%d/%m/%Y') AS 'Date',
    CONCAT('<a href="https://ccp-staff.koha-ptfs.co.uk/cgi-bin/koha/circ/circulation.pl?borrowernumber=', borrowers.borrowernumber, '#reserves">', borrowers.firstname, ' ', borrowers.surname, '<br />', '(', borrowers.cardnumber, ')' '</a>') AS 'Patron',
    CONCAT('<a href="https://ccp-staff.koha-ptfs.co.uk/cgi-bin/koha/catalogue/detail.pl?biblionumber=', biblio.biblionumber, '">', biblio.title, '</a>', '<br />', '<strong>', biblio.author, '</strong>', '<br />', ExtractValue(biblio_metadata.metadata, '//datafield[@tag="260"]/subfield[@code="b"]'), ', ', SUBSTR(ExtractValue(biblio_metadata.metadata,'//controlfield[@tag="008"]'),8,4), '<br />', 'ISBN: ', biblioitems.isbn) AS 'Title',
    av_collection.lib AS 'Collection',
    CONCAT('<em>', av_location.lib, '</em>', '<br />', ExtractValue(biblio_metadata.metadata, '//datafield[@tag="082"]/subfield[@code="a"]')) AS 'Call number',
    reserves.priority as 'Priority',
    CASE WHEN items.itemnumber IS NULL THEN '<em>Any available item</em>' ELSE CONCAT('<strong>', items.itemnumber, '</strong>', ' <em> or any available item</em>') END AS 'Barcode',
    CONCAT('<a class="btn btn-default" href="https://ccp-staff.koha-ptfs.co.uk/cgi-bin/koha/catalogue/detail.pl?biblionumber=', biblio.biblionumber, '#holdings" target="popup" onclick="window.open(\'https://ccp-staff.koha-ptfs.co.uk/cgi-bin/koha/catalogue/detail.pl?biblionumber=', biblio.biblionumber, '#holdings\',\'Viewing record: ', biblio.biblionumber, '\',\'width=1024,height=860\'); return false;">Check availability</a>') AS 'Item availability',
    CASE WHEN reserves.reservenotes IS NULL THEN 'None recorded' WHEN reserves.reservenotes = '' THEN 'None recorded' ELSE reserves.reservenotes END AS 'Notes'
FROM reserves
LEFT JOIN borrowers ON borrowers.borrowernumber = reserves.borrowernumber
LEFT JOIN biblio ON biblio.biblionumber = reserves.biblionumber
LEFT JOIN biblio_metadata ON biblio_metadata.biblionumber = reserves.biblionumber
LEFT JOIN biblioitems ON biblioitems.biblionumber = reserves.biblionumber
LEFT JOIN items items ON items.itemnumber = reserves.itemnumber
LEFT JOIN items itembib ON itembib.biblionumber = reserves.biblionumber
LEFT JOIN authorised_values av_location ON av_location.authorised_value = itembib.location
LEFT JOIN authorised_values av_collection ON av_collection.authorised_value = itembib.ccode
GROUP BY reserves.reserve_id
ORDER BY reserves.reservedate ASC, 
    borrowers.surname ASC,
    borrowers.firstname ASC
