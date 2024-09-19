-- Data cleaning

SELECT *
FROM layoffs;


-- 1.Remove duplicates
-- 2.Standardise data
-- 3.NULL values or blank values
-- 4.Remove unnecessary coloumns

-- Creating a duplicate table so that orginal data is not effected to changes.

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM
layoffs_staging;

INSERT layoffs_staging
SELECT*
FROM layoffs;

-- Finding Duplicates in the Data by using ROW NUMBER

SELECT *, ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;


WITH duplicate_cte AS
(
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_CTE
WHERE row_num>1;


SELECT *
FROM layoffs_staging
WHERE company='Casper';



WITH duplicate_cte AS
(
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_CTE
WHERE row_num>1;

-- Creating a new table to copy the data including row number

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;


SELECT * 
FROM layoffs_staging2
WHERE row_num=1;

-- Deleting the duplicate Rows

DELETE 
FROM layoffs_staging2
WHERE row_num>1;


-- Standardizing data 

-- Removing the extra Spaces
SELECT company, TRIM(company)
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET company=TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;


SELECT  industry
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT country
FROM layoffs_staging2
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- Changing the date coloum data type to date

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE ;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE industry is NULL
OR industry='';

SELECT *
FROM layoffs_staging2;

-- Removing NULL values

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry='';


SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company
AND t1.location=t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- Updating the industry where the comapnies are same 

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Airbn%';

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Deleting the coloums which are NULL

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2;

-- Deleting the row number coloumn which is not necessary for Analysis

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;























