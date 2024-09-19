-- Exploratory Data analysis

SELECT * 
FROM layoffs_staging2;

-- Viewing the  Maximum values of Total Laid off and Percentage Laid off

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Timeline of Layoffs in the data 

SELECT MIN(date), MAX(date)
FROM layoffs_staging2;

-- Total layoffs with respect to industry

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Total layoffs with respect to country

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Total layoffs with respect to country

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Total layoffs with respect to Staging of the company

SELECT STAGE, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY  STAGE 
ORDER BY 1 DESC;

-- Total layoffs with respect to Month

SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) is NOT NULL
GROUP BY  `MONTH`
ORDER BY 1 ASC;


-- Rolling Toatl of layoffs by month
WITH Rolling_total as
(
SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY  `MONTH`
)
SELECT `MONTH`, total_off, SUM(total_off) OVER( ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;



SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;



-- Top 5 companies with highest layoffs in the year.

WITH Company_Year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS RANKING
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * FROM Company_Year_Rank
WHERE RANKING<=5;













