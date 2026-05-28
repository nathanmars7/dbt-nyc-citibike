with trips as (

    select
        trip_date,
        usertype,
        count(bikeid)                           as total_trips,
        round(avg(trip_duration_minutes), 2)    as avg_trip_duration_mins,
        round(min(trip_duration_minutes), 2)    as min_trip_duration_mins,
        round(max(trip_duration_minutes), 2)    as max_trip_duration_mins
    from {{ ref('stg_citibike_trips') }}
    where usertype is not null
    group by trip_date, usertype
    order by trip_date, usertype

)

select * from trips