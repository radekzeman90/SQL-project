CREATE TABLE world_temperature AS 
SELECT
	`time`,
	`date`,
	`city`,
	CAST(REPLACE (temp,' °c','') AS double) AS temperature
FROM 
	weather;

CREATE TABLE  world_gust AS 
SELECT 
	`time`,
	`date`,
	`city`,
	CAST(REPLACE (gust, ' km/h','') AS double) AS wind_gust
FROM 
	weather;

CREATE TABLE  world_rain AS 
SELECT 
	`time`,
	`date`,
	`city`,
	CAST (REPLACE (rain, ' mm', '') AS decimal(3, 1)) AS precipitation
FROM 
	weather;

CREATE TABLE  t_radek_zeman_projekt_sql_final AS
#uprava v covid19_basic_differences a countries tak, aby se správně párovaly evropská hlavní města se státy
WITH covid19_data AS (
SELECT
	date,
	REPLACE ((REPLACE (country,
	'Czechia',
	'Czech republic')),
	'Burma',
	'Myanmar') AS country,
	confirmed,
	deaths,
	recovered
FROM
	covid19_basic_differences),
geography AS (
SELECT
	country,
	abbreviation,
	REPLACE (REPLACE(REPLACE(REPLACE(REPLACE (REPLACE(REPLACE (REPLACE (REPLACE (REPLACE (capital_city,
	'Praha',
	'Prague'),
	'Bruxelles [Brussel]',
	'Brussels'),
	'Wien',
	'Vienna'),
	'Helsinki [Helsingfors]',
	'Helsinki'),
	'Athenai',
	'Athens'),
	'Bucuresti',
	'Bucharest'),
	'Kyiv',
	'Kiev'),
	'Lisboa',
	'Lisbon'),
	'Roma',
	'Rome'),
	'Warszawa',
	'Warsaw') AS capital,
	population_density,
	population
FROM
	countries),
#upravena tabulka economies tak, aby generovala nejnovejsi data, kdyz data k roku 2020 nejsou
gini_table AS (
SELECT
	country,
	max(`year`) AS "year",
	gini
FROM
	economies
WHERE
	gini IS NOT NULL
GROUP BY
	country),
gdp_table AS (
SELECT
	country,
	max(`year`) AS "year",
	round (gdp / population,
	1) AS gdp_per_capita
FROM
	economies
WHERE
	gdp IS NOT NULL
GROUP BY
	country),
child_mortality AS (
SELECT
	country,
	max(`year`) AS "year",
	mortaliy_under5 AS mortality_under5
FROM
	economies
WHERE
	mortaliy_under5 IS NOT NULL
GROUP BY
	country),
#porovnání doby dožití
life_expectancy_1965 AS (
SELECT
	country,
	life_expectancy
FROM
	life_expectancy
WHERE
	year = 1965),
life_expectancy_2015 AS (
SELECT
	country,
	life_expectancy
FROM
	life_expectancy
WHERE
	year = 2015),
#nabozenstvi 
christianity_share AS (
SELECT
	country,
	share_pop_per_country AS christianity
FROM
	pop_religion_per_country
WHERE
	religion = 'christianity'
GROUP BY
	country),
islam_share AS (
SELECT
	country,
	share_pop_per_country AS islam
FROM
	pop_religion_per_country prpc
WHERE
	religion = 'islam'
GROUP BY
	country),
unaffiliated_share AS (
SELECT
	country,
	share_pop_per_country AS unaffiliated_religions
FROM
	pop_religion_per_country prpc
WHERE
	religion = 'unaffiliated religions'
GROUP BY
	country),
hinduism_share AS (
SELECT
	country,
	share_pop_per_country AS hinduism
FROM
	pop_religion_per_country prpc
WHERE
	religion = 'hinduism'
GROUP BY
	country),
buddhism_share AS (
SELECT
	country,
	share_pop_per_country AS buddhism
FROM
	pop_religion_per_country prpc
WHERE
	religion = 'buddhism'
GROUP BY
	country),
folk_share AS (
SELECT
	country,
	share_pop_per_country AS folk_religions
FROM
	pop_religion_per_country prpc
WHERE
	religion = 'folk religions'
GROUP BY
	country),
other_religion_share AS (
SELECT
	country,
	share_pop_per_country AS other_religions
FROM
	pop_religion_per_country prpc
WHERE
	religion = 'other religions'
GROUP BY
	country),
judaism_share AS (
SELECT
	country,
	share_pop_per_country AS judaism
FROM
	pop_religion_per_country prpc
WHERE
	religion = 'judaism'
GROUP BY
	country),
#pocasi
europe_rain AS (
SELECT
	`city`,
	`date`,
	count(precipitation)* 3 AS dry_hours
FROM
	world_rain
WHERE
	precipitation = 0
	AND `city` IS NOT NULL
GROUP BY
	`date`,
	`city`),
europe_wind AS (
SELECT
	`city`,
	`date`,
	max(wind_gust) AS gust
FROM
	world_gust
WHERE
	`city` IS NOT NULL
GROUP BY
	`date`,
	`city`),
europe_temperature AS (
SELECT
	`city`,
	`date`,
	avg(temperature) AS avg_day_temp
FROM
	world_temperature
WHERE
	`time`<"21:00"
	AND `time` >= "09:00"
	AND `city` IS NOT NULL
GROUP BY
	`date`,
	`city`)
SELECT
	covid19_data.`date`,
	covid19_data.country,
	covid19_data.confirmed,
	covid19_data.deaths,
	covid19_data.recovered,
	covid19_tests.tests_performed,
	geography.population_density,
	geography.population,
	gini_table.gini,
	gdp_table.gdp_per_capita,
	child_mortality.mortality_under5,
	median_age.median_age_2018,
	christianity_share.christianity,
	islam_share.islam,
	unaffiliated_share.unaffiliated_religions,
	hinduism_share.hinduism,
	buddhism_share.buddhism,
	folk_share.folk_religions,
	other_religion_share.other_religions,
	(life_expectancy_2015.life_expectancy-life_expectancy_1965.life_expectancy) AS life_expectancy_diff,
	europe_rain.dry_hours,
	europe_wind.gust,
	europe_temperature.avg_day_temp,
	#casove promenne	
	CASE
		WHEN weekday(covid19_data.`date`) in (0, 1, 2, 3, 4) THEN 0
		else 1
	END AS `workday_or_weekday`,
	CASE
		WHEN month(covid19_data.`date`) in (12, 1, 2) THEN 4
		WHEN month(covid19_data.`date`) in (3, 4, 5) THEN 3
		WHEN month(covid19_data.`date`) in (6, 7, 8) THEN 2
		WHEN month(covid19_data.`date`) in (9, 10, 11) THEN 1
	END AS season
FROM
	covid19_data
LEFT JOIN geography ON
	geography.country = covid19_data.country
LEFT JOIN covid19_tests ON
	covid19_tests.`date` = covid19_data.`date`
	AND covid19_tests.country = covid19_data.country
LEFT JOIN gini_table ON
	gini_table.country = covid19_data.country
LEFT JOIN gdp_table ON
	gdp_table.country = covid19_data.country
LEFT JOIN child_mortality ON
	child_mortality.country = covid19_data.country
LEFT JOIN life_expectancy_1965 ON
	life_expectancy_1965.country = covid19_data.country
LEFT JOIN life_expectancy_2015 ON
	life_expectancy_2015.country = covid19_data.country
LEFT JOIN median_age ON
	median_age.abbreviation = geography.abbreviation
LEFT JOIN christianity_share ON
	christianity_share.country = covid19_data.country
LEFT JOIN islam_share ON
	islam_share.country = covid19_data.country
LEFT JOIN unaffiliated_share ON
	unaffiliated_share.country = covid19_data.country
LEFT JOIN hinduism_share ON
	hinduism_share.country = covid19_data.country
LEFT JOIN buddhism_share ON
	buddhism_share.country = covid19_data.country
LEFT JOIN folk_share ON
	folk_share.country = covid19_data.country
LEFT JOIN other_religion_share ON
	other_religion_share.country = covid19_data.country
LEFT JOIN judaism_share ON
	judaism_share.country = covid19_data.country
LEFT JOIN europe_rain ON
	europe_rain.`date` = covid19_data.`date`
	AND europe_rain.city = geography.capital
LEFT JOIN europe_wind ON
	europe_wind.`date` = covid19_data.`date`
	AND europe_wind.city = geography.capital
LEFT JOIN europe_temperature ON
	europe_temperature.`date` = covid19_data.`date`
	AND europe_temperature.city = geography.capital
ORDER BY
	covid19_data.country;

