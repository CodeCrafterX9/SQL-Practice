/**
The Bloomberg terminal is the go-to resource for financial professionals, offering convenient access to a wide array of financial datasets. As a Data Analyst at Bloomberg, you have access to historical data on stock performance.

Currently, you're analyzing the highest and lowest open prices for each FAANG stock by month over the years.

For each FAANG stock, display the ticker symbol, the month and year ('Mon-YYYY') with the corresponding highest and lowest open prices (refer to the Example Output format). Ensure that the results are sorted by ticker symbol.

stock_prices Schema:
Column Name	Type	Description
date	datetime	The specified date (mm/dd/yyyy) of the stock data.
ticker	varchar	The stock ticker symbol (e.g., AAPL) for the corresponding company.
open	decimal	The opening price of the stock at the start of the trading day.
high	decimal	The highest price reached by the stock during the trading day.
low	decimal	The lowest price reached by the stock during the trading day.
close	decimal	The closing price of the stock at the end of the trading day.
stock_prices Example Input:
Note that the table below displays randomly selected AAPL data.

date	ticker	open	high	low	close
01/31/2023 00:00:00	AAPL	142.28	142.70	144.34	144.29
02/28/2023 00:00:00	AAPL	146.83	147.05	149.08	147.41
03/31/2023 00:00:00	AAPL	161.91	162.44	165.00	164.90
04/30/2023 00:00:00	AAPL	167.88	168.49	169.85	169.68
05/31/2023 00:00:00	AAPL	176.76	177.33	179.35	177.25
Example Output:
ticker	highest_mth	highest_open	lowest_mth	lowest_open
AAPL	May-2023	176.76	Jan-2023	142.28
Apple Inc. (AAPL) achieved its highest opening price of $176.76 in May 2023 and its lowest opening price of $142.28 in January 2023.

**/

with monthly as (
SELECT To_CHAR(date,'Mon-yyyy') as month,ticker,open opening
FROM stock_prices
group by 1,2,3),

tickers as (
select ticker, 
case when max_open =1 then month else 'skip' end as highest_month,
case when max_open =1 then opening else null end as highest_open,
case when min_open =1 then month else 'skip' end as lowest_month,
case when min_open =1 then opening else null end as lowest_open
from (
select *,rank() over (partition by ticker order by opening asc) min_open,
rank() over (partition by ticker order by opening desc) max_open
from monthly 
)t 
order by ticker)

select t1.ticker,t1.highest_month,t1.highest_open,
t2.lowest_month,t2.lowest_open
from tickers t1 join tickers t2
on t1.ticker=t2.ticker and t1.highest_month <> 'skip'
and t2.lowest_month <>'skip'
