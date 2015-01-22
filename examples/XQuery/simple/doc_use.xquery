for $x in doc("file:///tmp/__books.xml")/bookstore/book/title
order by $x
return $x 
