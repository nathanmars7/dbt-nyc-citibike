# dbt NYC Citibike Weather Analysis

A hands-on dbt project analysing the relationship between weather conditions and Citibike ridership in New York City using **dbt Core** and **Google BigQuery**.

## Project Overview

This project joins two public datasets — NYC Citibike trip data and NOAA weather readings — to answer the question:

> "How does weather affect Citibike ridership in New York City?"

Key finding: rainy days see ~13% fewer trips on average compared to dry days.

## Tech Stack

- **dbt Core** 1.11
- **Google BigQuery**
- **Python** 3.13

## Data Sources

| Source | Dataset | Description |
|--------|---------|-------------|
| Citibike trips | `bigquery-public-data.new_york_citibike` | Individual bike trip records 2016-2018 |
| NOAA weather | `bigquery-public-data.noaa_gsod` | Daily weather readings from Central Park station |

## Project Structure

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

## Models

| Model | Materialization | Description |
|-------|----------------|-------------|
| `stg_citibike_trips` | View | Cleans and renames raw Citibike trip records for 2016-2018 |
| `stg_weather_nyc` | View | Unions 3 years of NOAA weather data, filtered to Central Park station |
| `mart_citibike_daily_weather` | Table | Daily trip counts joined with weather — one row per day |
| `mart_citibike_by_usertype` | Table | Daily trip breakdown by user type (Subscriber vs Customer) |

## Key Concepts Demonstrated

- **Multiple sources** — two separate public datasets declared in sources.yml
- **Union across yearly tables** — combining gsod2016, gsod2017, gsod2018 in one staging model
- **Cross-source joins** — joining citibike and weather on trip date
- **Derived boolean flags** — is_rainy, is_freezing computed in staging
- **Folder-level materialization** — set in dbt_project.yml, not per file
- **Generic tests** — not_null, unique, accepted_values
- **accepted_values test** — validating usertype is always Subscriber or Customer

## Key Insight

    is_rainy | avg_trips_per_day
    ---------|-----------------
    false    | 44,444
    true     | 38,834

Rainy days average 13% fewer trips — clear evidence that weather significantly impacts Citibike demand.

## Getting Started

### Prerequisites

- Python 3.13+
- Google Cloud account with BigQuery enabled
- dbt Core with BigQuery adapter

### Setup

    git clone https://github.com/nathanmars7/dbt-nyc-citibike.git
    cd dbt-nyc-citibike
    python3 -m venv venv
    source venv/bin/activate
    pip install dbt-bigquery
    gcloud auth application-default login
    dbt debug

### Running the Project

    dbt run
    dbt test
    dbt docs generate
    dbt docs serve