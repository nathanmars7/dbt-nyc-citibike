with source as (

    select * from {{ source('new_york_citibike', 'citibike_trips') }}

),

renamed as (

    select
        bikeid,
        usertype,
        birth_year,
        gender,
        starttime,
        stoptime,
        DATE(starttime)                                         as trip_date,
        start_station_id,
        start_station_name,
        end_station_id,
        end_station_name,
        tripduration                                            as trip_duration_seconds,
        round(tripduration / 60.0, 2)                          as trip_duration_minutes
    from source
    where starttime is not null
        and starttime >= '2016-01-01'
        and starttime < '2019-01-01'

)

select * from renamed