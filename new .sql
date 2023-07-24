SELECT * FROM `india census 2011`.`india  census 2011`;
SELECT * FROM `india census 2011`.`india  census 2`;


-- number of rows in the dataset
SELECT COUNT(*) FROM `india census 2011`.`india  census 2011`;

-- dataset for Jharkhand and Bihar
SELECT * FROM `india census 2011`.`india  census 2011` WHERE state IN ('rajasthan', 'Bihar');

-- population of India
SELECT SUM(population) AS Population FROM `india census 2011`.`india census 2`;


-- average growth by state
SELECT state, AVG(growth) * 100 AS avg_growth FROM `india census 2011`.`india  census 2011` GROUP BY state;

-- average sex ratio by state
SELECT state, ROUND(AVG(sex_ratio), 0) AS avg_sex_ratio FROM `india census 2011`.`india  census 2011` GROUP BY state ORDER BY avg_sex_ratio DESC;

-- average literacy rate by state (greater than 90%)
SELECT state, ROUND(AVG(literacy), 0) AS avg_literacy_ratio FROM `india census 2011`.`india  census 2011` 
GROUP BY state HAVING ROUND(AVG(literacy), 0) > 90 ORDER BY avg_literacy_ratio DESC;

-- top 3 states showing the highest growth ratio
SELECT state, AVG(growth) * 100 AS avg_growth FROM `india census 2011`.`india  census 2011`
GROUP BY state ORDER BY avg_growth DESC LIMIT 3;

-- bottom 3 states showing the lowest sex ratio
SELECT state, ROUND(AVG(sex_ratio), 0) AS avg_sex_ratio FROM `india census 2011`.`india  census 2011`
GROUP BY state ORDER BY avg_sex_ratio ASC LIMIT 3;

-- top and bottom 3 states in terms of literacy rate
SELECT state, ROUND(AVG(literacy), 0) AS avg_literacy_ratio FROM `india census 2011`.`india  census 2011` 
GROUP BY state ORDER BY avg_literacy_ratio DESC LIMIT 3;

SELECT state, ROUND(AVG(literacy), 0) AS avg_literacy_ratio FROM `india census 2011`.`india  census 2011`
GROUP BY state ORDER BY avg_literacy_ratio ASC LIMIT 3;

-- states starting with letter 'A' or 'B'
SELECT DISTINCT state FROM `india census 2011`.`india  census 2011` WHERE LOWER(state) LIKE 'a%' OR LOWER(state) LIKE 'b%';

-- states starting with letter 'A' and ending with 'M'
SELECT DISTINCT state FROM `india census 2011`.`india  census 2011` WHERE LOWER(state) LIKE 'a%' AND LOWER(state) LIKE '%m';

SELECT d.state, SUM(d.males) AS total_males, SUM(d.females) AS total_females FROM (
    SELECT a.district, a.state, ROUND(a.population / (a.sex_ratio + 1), 0) AS males,
    ROUND((a.population * a.sex_ratio) / (a.sex_ratio + 1), 0) AS females
    FROM `india census 2011` a
    INNER JOIN `india census 2` b ON a.district = b.district
) d
GROUP BY d.state;

-- output top 3 districts from each state with the highest literacy rate
SELECT a.*
FROM (
    SELECT District, state, literacy, RANK() OVER (PARTITION BY state ORDER BY literacy DESC) AS rnk
    FROM `india census 2011`.`india  census 2011`
) a
WHERE a.rnk IN (1, 2, 3)
ORDER BY state;


-- total literacy rate by state
SELECT c.state, SUM(literate_people) AS total_literate_pop, SUM(illiterate_people) AS total_illiterate_pop
FROM (
    SELECT d.district, d.state, ROUND(d.literacy_ratio * d.population, 0) AS literate_people,
    ROUND((1 - d.literacy_ratio) * d.population, 0) AS illiterate_people
    FROM (
        SELECT a.district, a.state, a.literacy / 100 AS literacy_ratio, b.population
        FROM `india census 2011`.`india  census 2011` a
        INNER JOIN `india census 2` b ON a.district = b.district
    ) d
) c
GROUP BY c.state;

-- population in previous census and current census
SELECT SUM(m.previous_census_population) AS previous_census_population, SUM(m.current_census_population) AS current_census_population
FROM (
    SELECT e.state, SUM(e.previous_census_population) AS previous_census_population,
    SUM(e.current_census_population) AS current_census_population
    FROM (
        SELECT d.district, d.state, ROUND(d.population / (1 + d.growth), 0) AS previous_census_population,
        d.population AS current_census_population
        FROM (
            SELECT a.district, a.state, a.growth, b.population
            FROM `india census 2011`.`india  census 2011`a
            INNER JOIN `india census 2` b ON a.district = b.district
        ) d
    ) e
    GROUP BY e.state
) m;

-- population vs area
SELECT (g.total_area / g.previous_census_population) AS previous_census_population_vs_area,
    (g.total_area / g.current_census_population) AS current_census_population_vs_area
FROM (
    SELECT q.*, r.total_area
    FROM (
        SELECT '1' AS keyy, n.*
        FROM (
            SELECT SUM(m.previous_census_population) AS previous_census_population,
                SUM(m.current_census_population) AS current_census_population
            FROM (
                SELECT e.state, SUM(e.previous_census_population) AS previous_census_population,
                    SUM(e.current_census_population) AS current_census_population
                FROM (
                    SELECT d.district, d.state, ROUND(d.population / (1 + d.growth), 0) AS previous_census_population,
                        d.population AS current_census_population
                    FROM (
                        SELECT a.district, a.state, a.growth, b.population
                        FROM `india census 2011`.`india  census 2011`a
                        INNER JOIN `india census 2` b ON a.district = b.district
                    ) d
                ) e
                GROUP BY e.state
            ) m
        ) n
    ) q
    INNER JOIN (
        SELECT '1' AS keyy, z.*
        FROM (
            SELECT SUM(area_km2) AS total_area FROM `india census 2`
        ) z
    ) r ON q.keyy = r.keyy
) g;

-- output top 3 districts from each state with the highest literacy rate
SELECT a.*
FROM (
    SELECT district, state, literacy, RANK() OVER (PARTITION BY state ORDER BY literacy DESC) AS rnk
    FROM `india census 2011`.`india  census 2011`
) a
WHERE a.rnk IN (1, 2, 3)
ORDER BY state;

