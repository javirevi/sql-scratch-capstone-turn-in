
-- WARBY Parker --

/*.

1 - To help users find their perfect frame, Warby Parker has a Style Quiz that has the following questions:

"What are you looking for?"
"What's your fit?"
"Which shapes do you like?"
"Which colors do you like?"
"When was your last eye exam?"
The users' responses are stored in a table called survey.

Select all columns from the first 10 rows. What columns does the table have?

.*/

SELECT *
FROM survey
LIMIT 10;

/*.

2 - Users will "give up" at different points in the survey.

Let's analyze how many users move from Question 1 to Question 2, etc.

Create a quiz funnel using the GROUP BY command.

What is the number of responses for each question?

.*/

SELECT question, COUNT (DISTINCT user_id)
FROM survey
GROUP BY 1;

-- JAVIER questions: why DISTINCT > Because the user_id could be repeated, eventhough here there is no such case --


/*.

3 - Using a spreadsheet program like Excel or Google Sheets, calculate the percentage of users who answer each question.:

Which question(s) of the quiz have a lower completion rates?

What do you think is the reason?

Add this finding to your presentation slides!

.*/
--  Here - https://docs.google.com/spreadsheets/d/1RRDEkmUfFLa6w-vhQjxssd5bgC1XDYgSHmt84jkEjw8/edit --



/*.

Home Try-On Funnel:

4.
Warby Parker's purchase funnel is:

Take the Style Quiz → Home Try-On → Purchase the Perfect Pair of Glasses

During the Home Try-On stage, we will be conducting an A/B Test:

50% of the users will get 3 pairs to try on
50% of the users will get 5 pairs to try on
Let's find out whether or not users who get more pairs to try on at home will be more likely to make a purchase.

The data will be distributed across three tables:

quiz
home_try_on
purchase
Examine the first five rows of each table

What are the column names?

.*/


SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;


/*.

5.
We'd like to create a new table with the following layout:

user_id	is_home_try_on	number_of_pairs	is_purchase
4e8118dc	True	3	False
291f1cca	True	5	False
75122300	False	NULL	False
Each row will represent a single user from the browse table:

If the user has any entries in home_try_on, then is_home_try_on will be 'True'.
number_of_pairs comes from home_try_on table
If the user has any entries in is_purchase, then is_purchase will be 'True'.
Use a LEFT JOIN to combine the three tables, starting with the top of the funnel (browse) and ending with the bottom of the funnel (purchase).

Select only the first 10 rows from this table (otherwise, the query will run really slowly).

.*/

SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
	ON q.user_id = h.user_id
LEFT JOIN purchase p
	ON p.user_id = q.user_id
  LIMIT 10;


p.user_id IS NOT NULL AS 'is_purchase'


/*.

6 - Once we have the data in this format, we can analyze it in several ways:

We can calculate overall conversion rates by aggregating across all rows.
We can compare conversion from quiz→home_try_on and home_try_on→purchase.
We can calculate the difference in purchase rates between customers who had 3 number_of_pairs with ones who had 5.
And more!
We can also use the original tables to calculate things like:

The most common results of the style quiz.
The most common types of purchase made.
And more!
What are some actionable insights for Warby Parker?

.*/




/*.

7 - Great work! Now take all your queries and findings from this data and put together your presentation.

Make sure it is readable and visually appealing so that the reviewer will understand!

.*/


-- EXTRA Queries & Tables ---

-- TABLE 1 --

with q1 AS (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
	 p.user_id IS NOT NULL AS 'is_purchase'
   FROM quiz q
LEFT JOIN home_try_on h
	ON q.user_id = h.user_id
LEFT JOIN purchase p
	ON p.user_id = q.user_id)


  SELECT q1.number_of_pairs,
  			 SUM(q1.is_home_try_on) AS 'Try_on',
  			 SUM(q1.is_purchase) AS 'Purchases',
      	ROUND (1.0 * SUM(q1.is_purchase) / SUM(q1.is_home_try_on), 2) AS CVR
         FROM q1
         GROUP BY 1;

-- TABLE 2 --

SELECT price AS 'Price', COUNT (price) AS 'Sales'
FROM purchase
GROUP BY price;

-- TABLE 3 --

SELECT shape AS 'Shape', COUNT (shape) AS 'Sales'
FROM quiz
GROUP BY shape;

-- TABLE 4 --

SELECT model_name AS 'Model', COUNT (model_name) AS 'Sales'
FROM purchase
GROUP BY model_name;
