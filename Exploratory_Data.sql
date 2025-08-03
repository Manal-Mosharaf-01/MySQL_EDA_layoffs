SELECT *
FROM world_layoffs_new.layoffs_staging2;

-- maximum laid off
SELECT MAX(total_laid_off)
FROM world_layoffs_new.layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM world_layoffs_new.layoffs_staging2;

-- companies that had 100% lay off and order by total laid off in desc
SELECT *
FROM world_layoffs_new.layoffs_staging2
WHERE percentage_laid_off= 1
ORDER BY total_laid_off DESC;

-- companies that had 100% lay off and order by funds raised millions
SELECT *
FROM world_layoffs_new.layoffs_staging2
WHERE percentage_laid_off= 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- during covid time
SELECT MIN(`date`), MAX(`date`)
FROM world_layoffs_new.layoffs_staging2;

-- which company laid off the most
SELECT company, SUM(total_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- which industry laid off the most
SELECT industry, SUM(total_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- which country laid off the most
SELECT country, SUM(total_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT `date`, SUM(total_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY `date`
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;



-- which company laid off the most
SELECT company, SUM(percentage_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- which industry laid off the most
SELECT industry, SUM(percentage_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- which country laid off the most
SELECT country, SUM(percentage_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


-- rolling sum


SELECT `date`, SUM(total_laid_off) OVER(ORDER BY `date`)
FROM world_layoffs_new.layoffs_staging2
ORDER BY 2 ASC;

SELECT MONTH(`date`), SUM(total_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY MONTH(`date`)
ORDER BY 1 ASC;

-- normal sum for total laid off each month with year
SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off)
FROM world_layoffs_new.layoffs_staging2
GROUP BY `month`
ORDER BY 1 ASC;

-- rolling sum of total laid off by year and month
WITH rolling_sum AS (
SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) AS total
FROM world_layoffs_new.layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC )

SELECT `month`, total, SUM(total) OVER(ORDER BY `month`)
FROM rolling_sum
ORDER BY 3 ASC;
------------------------------
SELECT *
FROM world_layoffs_new.layoffs_staging2;

SELECT company, SUBSTRING(`date`,1,4) AS `year`, SUM(total_laid_off) AS total
FROM world_layoffs_new.layoffs_staging2
GROUP BY `year`, company
ORDER BY company ASC;

SELECT company, SUBSTRING(`date`,1,4) AS `year`, SUM(total_laid_off) AS total
FROM world_layoffs_new.layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY `year`, company
ORDER BY total DESC;

-- rank by which year which companies laid of the most

WITH per_year_lay_off AS(
SELECT company, SUBSTRING(`date`,1,4) AS `year`, SUM(total_laid_off) AS total
FROM world_layoffs_new.layoffs_staging2
GROUP BY `year`, company)

SELECT *, DENSE_RANK() OVER (PARTITION BY `year`ORDER BY total DESC) AS ranking
FROM per_year_lay_off
WHERE `year` IS NOT NULL
AND total IS NOT NULL
ORDER BY ranking ASC;

-- rank by which year which companies (top 5 companies) laid of the most

WITH per_year_lay_off AS(
SELECT company, SUBSTRING(`date`,1,4) AS `year`, SUM(total_laid_off) AS total
FROM world_layoffs_new.layoffs_staging2
GROUP BY `year`, company),

company_year_rank AS(
SELECT *, DENSE_RANK() OVER (PARTITION BY `year`ORDER BY total DESC) AS ranking
FROM per_year_lay_off
WHERE `year` IS NOT NULL
AND total IS NOT NULL)

SELECT *
FROM company_year_rank
WHERE ranking <= 5;

