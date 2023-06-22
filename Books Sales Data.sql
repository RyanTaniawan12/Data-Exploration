select * from dbo.bestbook

-- Average Sales per Genre
select Genre, avg([Approximate sales in millions]) as [Average Sales in Millions]
from bestbook
where [First published] is not null and Genre <> 'Null'
group by Genre


-- Books Written in Certain Languages
select [Original language], count([Original language]) as [Total Books]
from bestbook
where [First published] is not null and Genre <> 'Null'
group by [Original language]


-- 10 Best Selling Books
select top(10) Book, [Author(s)], [Approximate sales in millions]
from bestbook
where [First published] is not null
order by [Approximate sales in millions] desc

-- Total Sales per Genre
select Genre, sum([Approximate sales in millions]) as [Total Sales in Millions]
from bestbook
where [First published] is not null and Genre <> 'Null'
group by Genre
order by [Total Sales in Millions] desc

-- Top 10 Average Sales by Genre
select top(10) Genre, avg([Approximate sales in millions]) as [Average Sales in Millions]
from bestbook
where [First published] is not null and Genre <> 'Null'
group by Genre
order by [Average Sales in Millions] desc

-- Top 15 Authors With Best Sales
select top(15) [Author(s)], sum([Approximate sales in millions]) as [Total Sales in Millions]
from bestbook
where [First published] is not null and Genre <> 'Null'
group by [Author(s)]
order by [Total Sales in Millions] desc

-- Books Published Year 2000 and After
select *
from bestbook
where [First published] is not null and Genre <> 'Null' and [First published] >= 2000
