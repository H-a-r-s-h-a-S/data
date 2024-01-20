select order_status, count(*) as order_count 
from orders 
group by 1 
order by 2 desc ; 

select order_date, count(*) as order_count 
from orders 
group by 1 
order by 2 desc ; 

select to_char(order_date, 'yyyy-MM') order_month, count(*) as order_count 
from orders 
group by 1
order by 2 desc ; 

SELECT order_item_order_id, round(sum(order_item_subtotal)::numeric,2) as order_revenue 
from order_items 
group by 1
order by 1 ;

select order_date, count(*) as order_count
from orders 
where order_status in ('COMPLETE', 'CLOSED') 
group by 1
having count(*) >= 120
order by 2 desc 
limit 5 ;

-- order of execution
-- from
-- join / where
-- group by
-- having
-- select
-- order by
-- offset
-- limit

select
	o.order_date, 
	oi.order_item_product_id , 
	oi.order_item_subtotal 
from orders o
	join order_items oi 
		on o.order_id = oi.order_item_order_id ;
	
	
select count(distinct order_id) from orders ; -- 68883

select count(distinct order_item_order_id) from order_items ; -- 57431

-- left outer join
select 
	o.order_id,
	o.order_date ,
	oi.order_item_id,
	oi.order_item_product_id , 
	oi.order_item_subtotal 
from orders o
	left outer join order_items oi 
		on o.order_id = oi.order_item_order_id 
order by 1 ;

-- full outer join
select 
	o.order_id,
	o.order_date ,
	oi.order_item_id,
	oi.order_item_product_id , 
	oi.order_item_subtotal 
from orders o
	full outer join order_items oi 
		on o.order_id = oi.order_item_order_id 
order by 1 ;

select
	o.order_date, 
	oi.order_item_product_id , 
	round(sum(oi.order_item_subtotal)::numeric,2) as order_revenue 
from orders o
	join order_items oi 
		on o.order_id = oi.order_item_order_id 
group by 1, 2
order by 1, 3 desc ;
	
-- views
create or replace view order_details_v 
as
select
	o.*,
	oi.order_item_product_id,
	oi.order_item_subtotal,
	oi.order_item_id
from orders o
	join order_items oi 
		on o.order_id = oi.order_item_order_id ;
	
explain select * from order_details_v where order_id=2;

-- products not sold in a given month
-- explain analyze verbose 
select count(*)
from products p 
left outer join order_details_v odv
on p.product_id = odv.order_item_product_id
and to_char(odv.order_date::timestamp, 'yyyy-MM') = '2014-01'
and odv.order_item_product_id is null and 1=2

except 

select *
from products p 
left outer join order_details_v odv
on p.product_id = odv.order_item_product_id
and to_char(odv.order_date::timestamp, 'yyyy-MM') = '2014-01'
where odv.order_item_product_id is null ;

select case when to_char(null::timestamp, 'yyyy-MM')='2014-01' then 1 else 0 end as test ;

select * from products p 
where not exists (select 1 from order_details_v odv where p.product_id=odv.order_item_product_id
and to_char(odv.order_date::timestamp, 'yyyy-MM') = '2014-01' ) ; -- 1246

