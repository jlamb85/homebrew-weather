
# Changelog

## [Unreleased]
- (pending changes)

## 2026-01-26
- Added support for `-wf` as a shorthand for `--weather-favorites`.
- Documented `-wf` in help/usage text and README.
- Wind speed now displays in both knots and mph when using Fahrenheit/imperial units.
- Improved forecast table alignment, especially for emoji and short weather words.
- Output now displays the weather data source/provider.
- Configurable weather provider and unit via `config.json`.
- Multiple weather data sources supported in config.
- Robust argument parsing and error handling.
- Dependency checks for `requests` and `wcwidth`.
- 7-day (or custom N-day) forecast with table output.
- ICAO and IATA code support for airport lookup.
- Batch weather for all favorites.
- Debug output and output file support.
