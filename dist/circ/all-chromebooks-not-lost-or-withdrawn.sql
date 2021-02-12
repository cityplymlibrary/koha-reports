SELECT items.barcode,items.dateaccessioned,items.homebranch,
	items.datelastborrowed,items.datelastseen,items.itemcallnumber,items.issues,
	items.renewals,items.ccode,items.enumchron
FROM items
WHERE items.itype = 'ANN-CB'
AND items.barcode IS NOT NULL
AND items.itemlost = 0
AND items.withdrawn = 0
