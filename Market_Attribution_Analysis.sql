select * from page_visits limit 10 ;

select distinct utm_campaign from page_visits ; 

select distinct utm_source from page_visits ; 

select distinct page_name from page_visits ; 

with first_touch as(
     select user_id , min(timestamp) as first_touch_at from page_visits group by 1
) 
SELECT ft.user_id,
        ft.first_touch_at,
        pv.utm_source,
        pv.utm_campaign,
        count(utm_campaign)
 FROM first_touch ft
 JOIN page_visits pv
   ON ft.user_id = pv.user_id
   AND ft.first_touch_at = pv.timestamp
   group by 3,4 order by 5 ;

with last_touch as 
(select user_id , max(timestamp) as last_touch_at from page_visits group by 1) ,
lt_attr as (
 SELECT lt.user_id,
        lt.last_touch_at,
        pv.utm_source,
        pv.utm_campaign
 FROM last_touch lt
 JOIN page_visits pv
   ON lt.user_id = pv.user_id
   AND lt.last_touch_at = pv.timestamp
)
select lt_attr.utm_source,
      lt_attr.utm_campaign,
      COUNT(*) from lt_attr
      group by 1 , 2 order by 3 desc ; 

select count(*) from page_visits where page_name = '4 - purchase'
