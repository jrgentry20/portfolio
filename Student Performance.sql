--Finding Trends in Student Performance
--This project will involve Data Cleaning and Exploration to see what variables affect student performance the most.
--This project used Student Performance data acquired on Kaggle (https://www.kaggle.com/datasets/rabieelkharoua/students-performance-dataset). 
--The purpose of this project was to clean and explore the data using SSMS to find trends in what was affecting student performance at a high school. 

--View Table
SELECT *
FROM PortfolioProject.dbo.Student_Performance


--1. Cleaning First!  I will change numbers in different fields to descriptions for clarity purposes as well as field names, and round the GPA to 2 decimal points


--1a.Change 0's in Gender to Male and 1's to Female

ALTER TABLE PortfolioProject.dbo.Student_Performance
ALTER COLUMN Gender varchar(10);

UPDATE PortfolioProject.dbo.Student_Performance
SET Gender = 
CASE WHEN Gender = 0 THEN 'Male'
     WHEN Gender = 1 THEN 'Female'
     ELSE Gender
     END;

--1b.Change Ethnicity Numbers to Descriptions
		--0: Caucasian, 1: African American, 2: Asian 3: Other

ALTER TABLE PortfolioProject.dbo.Student_Performance
ALTER COLUMN Ethnicity varchar(20);

UPDATE PortfolioProject.dbo.Student_Performance
SET Ethnicity = 
CASE WHEN Ethnicity = 0 THEN 'Caucasian'
     WHEN Ethnicity = 1 THEN 'African American'
	 WHEN Ethnicity = 2 THEN 'Asian'
	 WHEN Ethnicity = 3 THEN 'Other'
     ELSE Ethnicity
     END;

--1c.Change ParentalEducation Numbers to Descriptions
		--0: None, 1: High School, 2: Some College, 3: Bachelor's, 4: Higher

ALTER TABLE PortfolioProject.dbo.Student_Performance
ALTER COLUMN ParentalEducation varchar(20);

UPDATE PortfolioProject.dbo.Student_Performance
SET ParentalEducation = 
CASE WHEN ParentalEducation = 0 THEN 'None'
     WHEN ParentalEducation = 1 THEN 'High School'
	 WHEN ParentalEducation = 2 THEN 'Some College'
	 WHEN ParentalEducation = 3 THEN 'Bachelors'
	 WHEN ParentalEducation = 4 THEN 'Higher'
     ELSE ParentalEducation
     END;

--1d.Changed StudyTimeWeekly to WeeklyStudyHours for Clarity Using the Object Explorer

--1e.Change Tutoring from Numbers to Descriptions for Clarity

ALTER TABLE PortfolioProject.dbo.Student_Performance
ALTER COLUMN Tutoring varchar(10);

UPDATE PortfolioProject.dbo.Student_Performance
SET Tutoring = 
CASE WHEN Tutoring = 0 THEN 'No'
     WHEN Tutoring = 1 THEN 'Yes'
     ELSE Tutoring
     END;

--1f.Change ParentalSupport From Numbers to Descriptions for Clarity
		--0: None, 1: Low, 2: Moderate, 3: High, 4: Very High

ALTER TABLE PortfolioProject.dbo.Student_Performance
ALTER COLUMN ParentalSupport varchar(20);

UPDATE PortfolioProject.dbo.Student_Performance
SET ParentalSupport = 
CASE WHEN ParentalSupport = 0 THEN 'None'
     WHEN ParentalSupport = 1 THEN 'Low'
	 WHEN ParentalSupport = 2 THEN 'Moderate'
	 WHEN ParentalSupport = 3 THEN 'High'
	 WHEN ParentalSupport = 4 THEN 'Very High'
     ELSE ParentalSupport
     END;

--1g.Change Extracurricular From Numbers to Descriptions For Clarity

ALTER TABLE PortfolioProject.dbo.Student_Performance
ALTER COLUMN Extracurricular varchar(10);

UPDATE PortfolioProject.dbo.Student_Performance
SET Extracurricular = 
CASE WHEN Extracurricular = 0 THEN 'No'
     WHEN Extracurricular = 1 THEN 'Yes'
     ELSE Extracurricular
     END;

--1h.Change Sports From Numbers to Descriptions For Clarity

ALTER TABLE PortfolioProject.dbo.Student_Performance
ALTER COLUMN Sports varchar(10);

UPDATE PortfolioProject.dbo.Student_Performance
SET Sports = 
CASE WHEN Sports = 0 THEN 'No'
     WHEN Sports = 1 THEN 'Yes'
     ELSE Sports
     END;

--1i.Change Music From Numbers to Descriptions For Clarity

ALTER TABLE PortfolioProject.dbo.Student_Performance
ALTER COLUMN Music varchar(10);

UPDATE PortfolioProject.dbo.Student_Performance
SET Music = 
CASE WHEN Music = 0 THEN 'No'
     WHEN Music = 1 THEN 'Yes'
     ELSE Music
     END;

--1j.Change Volunteering From Numbers to Descriptions For Clarity

ALTER TABLE PortfolioProject.dbo.Student_Performance
ALTER COLUMN Volunteering varchar(10);

UPDATE PortfolioProject.dbo.Student_Performance
SET Volunteering = 
CASE WHEN Volunteering = 0 THEN 'No'
     WHEN Volunteering = 1 THEN 'Yes'
     ELSE Volunteering
     END;

--1k.Round GPA to 2 Decimal Places

UPDATE PortfolioProject.dbo.Student_Performance
SET GPA = ROUND(GPA, 2);

--1l.Change GradeClass Heading to GPAClassification for Clarity
--1m.Change GradeClass From Numbers to Descriptions For Clarity
		--0: 'A' (GPA >= 3.5), 1: 'B' (3.0 <= GPA < 3.5), 2: 'C' (2.5 <= GPA < 3.0), 3: 'D' (2.0 <= GPA < 2.5), 4: 'F' (GPA < 2.0)

ALTER TABLE PortfolioProject.dbo.Student_Performance
ALTER COLUMN GPAClassification varchar(20);

UPDATE PortfolioProject.dbo.Student_Performance
SET GPAClassification = 
CASE WHEN GPAClassification = 0 THEN 'A'
     WHEN GPAClassification = 1 THEN 'B'
	 WHEN GPAClassification = 2 THEN 'C'
	 WHEN GPAClassification = 3 THEN 'D'
	 WHEN GPAClassification = 4 THEN 'F'
     ELSE GPAClassification
     END;





--Exploration of the Data!
--Now that the data is cleaned I will look at different variables to find what is affecting student performance the most.

--2.How does gender affect student performance?
SELECT 
	   Gender,
	   COUNT(GPAClassification) as NumberOfStudents, 
	   GPAClassification
FROM PortfolioProject.dbo.Student_Performance
GROUP BY Gender, GPAClassification
ORDER BY GPAClassification ASC
		--Males and Females are pretty close in numbers at each GPAClassification; there isn't a noticeable difference
		--As GPAClassification gets lower we have way more students

--3.How does studying affect student performance?
SELECT 
	ROUND(AVG(WeeklyStudyHours),2), 
	GPAClassification
FROM PortfolioProject.dbo.Student_Performance
GROUP BY GPAClassification
ORDER BY AVG(WeeklyStudyHours) DESC;
		--Those with A's study almost 3 hours more a week than those with Fs
		--The more students study the higher the grade on average, it correlates throughout the range of GPAClassification

--4.How do absences affect student performance?
SELECT 
	ROUND(AVG(Absences), 2),
	GPAClassification
FROM PortfolioProject.dbo.Student_Performance
GROUP BY GPAClassification
ORDER BY AVG(Absences) DESC;
		--Those with lower grades have way more absences
		--Those with Fs have an average of 20.7 absences while those with As have an average of 5.7
		--Interesting note that those with Bs(5.3) have fewer absences than those with As(5.7)


--5.Find the percentage of those per Classification that do Extracurriculars
WITH ExtracurricularCounts AS (  
  SELECT
    GPAClassification,
    COUNT(*) AS TotalStudents,
    SUM(CASE WHEN Extracurricular = 'Yes' THEN 1 ELSE 0 END) AS ExtracurricularStudents
  FROM PortfolioProject.dbo.Student_Performance
  GROUP BY GPAClassification
  )
SELECT
  GPAClassification,
  ROUND(((CAST(ExtracurricularStudents as Float) * 1.0 / TotalStudents) * 100),2) AS ExtracurricularPercentage
FROM ExtracurricularCounts
ORDER BY ExtracurricularPercentage DESC;
		--In general, a higher percentage of those with higher grades participate in extracurriculars
		--51% of those with A's do extracurriculars while about 36% of those with D's and F's participate

--6.Find the percentage of those per Classification that do Sports
WITH SportsCounts AS (  
  SELECT
    GPAClassification,
    COUNT(*) AS TotalStudents,
    SUM(CASE WHEN Sports = 'Yes' THEN 1 ELSE 0 END) AS SportsStudents
  FROM PortfolioProject.dbo.Student_Performance
  GROUP BY GPAClassification
  )
SELECT
  GPAClassification,
  ROUND(((CAST(SportsStudents as Float) * 1.0 / TotalStudents) * 100),2) AS SportsPercentage
FROM SportsCounts
ORDER BY SportsPercentage DESC;
		--There is less of a gap as 35% of those with A's participate and 29% of those with F's do
		--This is less linear with those with C's participating the least

--7.Find the percentage of those per Classification that do Music
WITH MusicCounts AS (  
  SELECT
    GPAClassification,
    COUNT(*) AS TotalStudents,
    SUM(CASE WHEN Music = 'Yes' THEN 1 ELSE 0 END) AS MusicStudents
  FROM PortfolioProject.dbo.Student_Performance
  GROUP BY GPAClassification
  )
SELECT
  GPAClassification,
  ROUND(((CAST(MusicStudents as Float) * 1.0 / TotalStudents) * 100),2) AS MusicPercentage
FROM MusicCounts
ORDER BY MusicPercentage DESC;
		--There is less of a gap as 19% of those with A's participate and 18% of those with F's do
		--B's have the highest with 26% and the order most to least is B,A,D,C,F

--8.Find the percentage of those per Classification that do Volunteering
WITH VolunteeringCounts AS (  
  SELECT
    GPAClassification,
    COUNT(*) AS TotalStudents,
    SUM(CASE WHEN Volunteering = 'Yes' THEN 1 ELSE 0 END) AS VolunteeringStudents
  FROM PortfolioProject.dbo.Student_Performance
  GROUP BY GPAClassification
  )
SELECT
  GPAClassification,
  ROUND(((CAST(VolunteeringStudents as Float) * 1.0 / TotalStudents) * 100),2) AS VolunteeringPercentage
FROM VolunteeringCounts
ORDER BY VolunteeringPercentage DESC;
		--Those with A's have the least participation at 14% while those with F's have the most at 16%
		--There is a small spread between most and least

--9.(Compilation of 5,6,7,8) Put all the activity percentages together
WITH ActivityCounts AS (
  SELECT
    GPAClassification,
    SUM(CASE WHEN Extracurricular = 'Yes' THEN 1 ELSE 0 END) AS ExtracurricularStudents,
    SUM(CASE WHEN Sports = 'Yes' THEN 1 ELSE 0 END) AS SportsStudents,
    SUM(CASE WHEN Music = 'Yes' THEN 1 ELSE 0 END) AS MusicStudents,
    SUM(CASE WHEN Volunteering = 'Yes' THEN 1 ELSE 0 END) AS VolunteeringStudents,
    COUNT(*) AS TotalStudents
  FROM PortfolioProject.dbo.Student_Performance
  GROUP BY GPAClassification
)
SELECT
  GPAClassification,
  ROUND(((CAST(ExtracurricularStudents as Float) * 1.0 / TotalStudents) * 100),2) AS ExtracurricularPercentage,
  ROUND(((CAST(SportsStudents as Float) * 1.0 / TotalStudents) * 100),2) AS SportsPercentage,
  ROUND(((CAST(MusicStudents as Float) * 1.0 / TotalStudents) * 100),2) AS MusicPercentage,
  ROUND(((CAST(VolunteeringStudents as Float) * 1.0 / TotalStudents) * 100),2) AS VolunteeringPercentage
FROM ActivityCounts
ORDER BY GPAClassification ASC;
		--In general students with higher grades are participating in more activities but it's not always the case
		--The one that has the biggest spread is extracurriculars while the other three have less of a spread
		--Volunteering has those with A's as the lowest percentage while those with F's have the highest


--10.How does Parental Education and Parental Support Impact grades?
WITH ParentalSupportCounts AS (
  SELECT
    GPAClassification,
    ParentalSupport,
    COUNT(*) AS TotalStudents
  FROM PortfolioProject.dbo.Student_Performance
  GROUP BY GPAClassification, ParentalSupport
)
SELECT
  GPAClassification,
  ParentalSupport,
  ROUND(((CAST(TotalStudents AS FLOAT) / SUM(TotalStudents) OVER (PARTITION BY GPAClassification)) * 100),2) AS SupportPercentage
FROM ParentalSupportCounts
ORDER BY GPAClassification ASC, SupportPercentage DESC;
		--A's tend to have a larger percentage for "High" and "Very High" support.  "Very High" is low on all the other grades and both "Moderate" and "High" top percentages for others although at lower percentages than those with A's
		--Combining "Very High" and "High" support for each classification looks like:
		--A's-67.3%, B's-46.5%, C's-38.8%, D's-41.3%, F's-35.6%

--11.See how Parental Education Affects Grade
WITH ParentalEducationCounts AS (
  SELECT
    GPAClassification,
    ParentalEducation,
    COUNT(*) AS TotalStudents
  FROM PortfolioProject.dbo.Student_Performance
  GROUP BY GPAClassification, ParentalEducation
)
SELECT
  GPAClassification,
  ParentalEducation,
  ROUND(((CAST(TotalStudents AS FLOAT) / SUM(TotalStudents) OVER (PARTITION BY GPAClassification)) * 100),2) AS EducationPercentage
FROM ParentalEducationCounts
ORDER BY GPAClassification ASC, EducationPercentage DESC;
		--For all grade classifications "Some College" is the highest percentage and numbers/order are fairly similar as you go to other education
		--There is less of a correlation for ParentalEducation than for ParentalSupport


--12.How does Ethnicity come into play?

--12a.Find the total number of students per ethnicity to help with queries below
SELECT
    Ethnicity,
	COUNT(Ethnicity) AS NumberOfStudents
FROM PortfolioProject.dbo.Student_Performance
GROUP BY Ethnicity
		--222 Other, 493 African American, 470 Asian, 1207 Caucasian


--12b.Grade Breakdown by percentages for Asian Students
WITH GPAClassificationCounts AS (
  SELECT
    GPAClassification,
	Ethnicity,
    COUNT(*) AS NumberOfStudents
  FROM PortfolioProject.dbo.Student_Performance
  WHERE Ethnicity = 'Asian'
  GROUP BY GPAClassification, Ethnicity
)
SELECT
  GPAClassification,
  Ethnicity,
  NumberOfStudents,
  ROUND(((CAST(NumberOfStudents as Float) * 1.0 / 470) * 100),2) AS Percentage
FROM GPAClassificationCounts
ORDER BY GPAClassification ASC;
		--49% of Asian students have an F vs 6% having an A


--12c.Grade Breakdown by percentages for African American Students
WITH GPAClassificationCounts AS (
  SELECT
    GPAClassification,
	Ethnicity,
    COUNT(*) AS NumberOfStudents
  FROM PortfolioProject.dbo.Student_Performance
  WHERE Ethnicity = 'African American'
  GROUP BY GPAClassification, Ethnicity
)
SELECT
  GPAClassification,
  Ethnicity,
  NumberOfStudents,
  ROUND(((CAST(NumberOfStudents as Float) * 1.0 / 493) * 100),2) AS Percentage
FROM GPAClassificationCounts
ORDER BY GPAClassification ASC;
		--49% of African American students have an F vs 5% having an A

--12d.Grade Breakdown by percentages for Other Students
WITH GPAClassificationCounts AS (
  SELECT
    GPAClassification,
	Ethnicity,
    COUNT(*) AS NumberOfStudents
  FROM PortfolioProject.dbo.Student_Performance
  WHERE Ethnicity = 'Other'
  GROUP BY GPAClassification, Ethnicity
)
SELECT
  GPAClassification,
  Ethnicity,
  NumberOfStudents,
  ROUND(((CAST(NumberOfStudents as Float) * 1.0 / 222) * 100),2) AS Percentage
FROM GPAClassificationCounts
ORDER BY GPAClassification ASC;
		--47% of Asian students have an F vs 4% having an A

--12e.Grade Breakdown by percentages for Caucasion Students
WITH GPAClassificationCounts AS (
  SELECT
    GPAClassification,
	Ethnicity,
    COUNT(*) AS NumberOfStudents
  FROM PortfolioProject.dbo.Student_Performance
  WHERE Ethnicity = 'Caucasian'
  GROUP BY GPAClassification, Ethnicity
)
SELECT
  GPAClassification,
  Ethnicity,
  NumberOfStudents,
  ROUND(((CAST(NumberOfStudents as Float) * 1.0 / 1207) * 100),2) AS Percentage
FROM GPAClassificationCounts
ORDER BY GPAClassification ASC;
		--52% of Caucasion students have an F vs 4% having an A

--For ethnicity, each group has a similar percentage breakdown per GPAClassification

--13.Does Tutoring help?
WITH TutoringCounts AS (
  SELECT
    GPAClassification,
    Tutoring,
    COUNT(Tutoring) AS Number
  FROM PortfolioProject.dbo.Student_Performance
  GROUP BY GPAClassification, Tutoring
)
SELECT
  GPAClassification,
  Tutoring,
  Number,
  ROUND((CAST(Number AS FLOAT) / SUM(Number) OVER (PARTITION BY GPAClassification)) * 100,2) AS Percentage
FROM TutoringCounts
ORDER BY GPAClassification, Tutoring;
		--In each GPAClassification more students don't participate in tutoring than do
		--There is a bigger spread between those that do and don't for D's and F's but not a noticeable advantage for those with A's and B's


--TAKEAWAYS-What is affecting student performance the most?
	--1.Studying
			--Those with A's study almost 3 hours more a week than those with Fs
		    --The more students study the higher the grade on average, it correlates throughout the range of GPAClassification
	--2.Absences
			--Those with lower grades have way more absences
		    --Those with Fs have an average of 20.7 absences while those with As have an average of 5.7
		    --Interesting note that those with Bs(5.3) have fewer absences than those with As(5.7)
	--3.Parental Support
			--A's tend to have a larger percentage for "High" and "Very High" support.  "Very High" is low on all the other grades and both "Moderate" and "High" top percentages for others although at lower percentages than those with A's
			--Combining "Very High" and "High" support for each classification looks like:
			--A's-67.3%, B's-46.5%, C's-38.8%, D's-41.3%, F's-35.6%
	--4.Extracurriculars
			--In general, a higher percentage of those with higher grades participate in extracurriculars
			--51% of those with A's do extracurriculars while about 36% of those with D's and F's participate

--Correlation doesn't = causation but those 4 factors stand out the most as creating a difference between GPA Classifications.
--More data could be helpful with breakdowns of socioeconomic status, grades per class or subject, how grades have changed over the years, or more.
--My plan is to now visualize this data in Tableau.
