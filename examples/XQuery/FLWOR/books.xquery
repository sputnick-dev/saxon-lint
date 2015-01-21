<books>{
for $x in /bookstore/book
where $x/price>30
order by $x/title
return $x/title
}</books>
