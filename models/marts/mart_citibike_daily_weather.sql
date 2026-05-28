with trips as (

    select
        trip_date,
        count(bikeid)                       as total_trips,
        round(avg(trip_duration_minutes), 2) as avg_trip_duration_mins,
        countif(usertype = 'Subscriber')    as subscriber_trips,
        countif(usertype = 'Customer')      as customer_trips
    from {{ ref('stg_citibike_trips') }}
    group by trip_date

),

weather as (

    select
        weather_date,
        avg_temp_f,
        avg_temp_c,
        avg_wind_speed,
        precipitation,
        visibility,
        is_rainy,
        is_freezing
    from {{ ref('stg_weather_nyc') }}

),

final as (

    select
        trips.trip_date,
        trips.total_trips,
        trips.avg_trip_duration_mins,
        trips.subscriber_trips,
        trips.customer_trips,
        weather.avg_temp_f,
        weather.avg_temp_c,
        weather.avg_wind_speed,
        weather.precipitation,
        weather.is_rainy,
        weather.is_freezing
    from trips
    left join weather
        on trips.trip_date = weather.weather_date

)

select * from final