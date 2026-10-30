# dbt NYC Citibike Weather Analysis

A dbt Core project on Google BigQuery that joins two public datasets, NYC Citibike trips and NOAA daily weather readings, to look at how weather relates to Citibike ridership in New York City between 2016 and 2018.

## At a glance

| | |
|---|---|
| Stack | dbt Core 1.11, Python 3.13 |
| Warehouse | Google BigQuery |
| Data | `bigquery-public-data.new_york_citibike` (trips, 2016-2018) and `bigquery-public-data.noaa_gsod` (daily weather, gsod2016 to gsod2018) |
| What it shows | Two sources declared in `sources.yml`, a union across yearly tables, a cross-source join on date, derived boolean flags, folder-level materialization, and generic tests (`not_null`, `unique`, `accepted_values`) |
| Status | Portfolio project, complete. Last verified 2026-05 from the repo contents. |

## Project structure

    models/
    ├── staging/
    │   ├── sources.yml
    │   ├── schema.yml
    │   ├── stg_citibike_trips.sql
    │   └── stg_weather_nyc.sql
    └── marts/
        ├── schema.yml
        ├── mart_citibike_daily_weather.sql
        └── mart_citibike_by_usertype.sql

Staging models are materialized as views and marts as tables, set per folder in `dbt_project.yml`. The `analyses/`, `macros/`, `seeds/`, `snapshots/` and `tests/` folders are empty.

## Run it

You need a Google Cloud project with BigQuery enabled. The public datasets are free to read; queries are billed to your project.

    git clone https://github.com/nathanmars7/dbt-nyc-citibike.git
    cd dbt-nyc-citibike
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    gcloud auth application-default login

Add a profile named `dbt_nyc_citibike` (the name set in `dbt_project.yml`) to `~/.dbt/profiles.yml`, pointing at your own project and dataset:

    dbt_nyc_citibike:
      target: dev
      outputs:
        dev:
          type: bigquery
          method: oauth
          project: your-gcp-project
          dataset: dbt_nyc_citibike
          location: US
          threads: 4

Then build and document:

    dbt debug
    dbt build
    dbt docs generate
    dbt docs serve

There is no `packages.yml` and no seeds, so `dbt deps` and `dbt seed` are not needed.

## Models

| Model | Materialization | Description |
|---|---|---|
| `stg_citibike_trips` | View | Cleans and renames raw Citibike trip records, filtered to trips starting 2016-2018, with trip date and duration in minutes |
| `stg_weather_nyc` | View | Unions `gsod2016`, `gsod2017` and `gsod2018`, filtered to station `725030` (labelled Central Park in the model), with temperature, wind, precipitation, visibility and `is_rainy` / `is_freezing` flags |
| `mart_citibike_daily_weather` | Table | Daily trip counts, average duration and subscriber/customer split, left-joined to that day's weather. One row per day |
| `mart_citibike_by_usertype` | Table | Daily trip counts and duration statistics per user type (Subscriber or Customer) |

## Key finding

As reported when the project was run (not reproducible from the repo alone):

    is_rainy | avg_trips_per_day
    ---------|-----------------
    false    | 44,444
    true     | 38,834

Rainy days (precipitation over 0.1 inches) averaged about 13% fewer trips than dry days.

## Portfolio

Part of a set of data engineering portfolio projects:

- https://github.com/nathanmars7/dbt-analytics-engineering : dbt on DuckDB and Snowflake from one codebase
- https://github.com/nathanmars7/jaffle-shop-snowflake : minimal dbt starter on Snowflake
- https://github.com/nathanmars7/dbt-nyc-citibike : dbt on BigQuery, Citibike ridership vs weather (this repo)
- https://github.com/nathanmars7/dbt-crypto-bitcoin : dbt on BigQuery with snapshots, Bitcoin transactions
- https://github.com/nathanmars7/dbt-learning : dbt on BigQuery, Chicago taxi trips, incremental models
- https://github.com/nathanmars7/pyspark-fraud-pipeline : PySpark and Delta Lake medallion pipeline on Databricks
