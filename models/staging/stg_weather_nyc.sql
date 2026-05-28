with source as (

    select * from {{ source('noaa_gsod', 'gsod2016') }}
    union all
    select * from {{ source('noaa_gsod', 'gsod2017') }}
    union all
    select * from {{ source('noaa_gsod', 'gsod2018') }}

),

renamed as (

    select
        stn                                                     as station_id,
        PARSE_DATE('%Y%m%d', concat(year, mo, da))              as weather_date,
        round(cast(temp as float64), 1)                         as avg_temp_f,
        round((cast(temp as float64) - 32) * 5/9, 1)           as avg_temp_c,
        round(cast(wdsp as float64), 1)                         as avg_wind_speed,
        round(cast(prcp as float64), 2)                         as precipitation,
        round(cast(visib as float64), 1)                        as visibility,
        if(cast(prcp as float64) > 0.1, true, false)            as is_rainy,
        if(cast(temp as float64) < 32, true, false)             as is_freezing
    from source
    where stn = '725030'  -- Central Park weather station
        and year in ('2016', '2017', '2018')

)

select * from renamed