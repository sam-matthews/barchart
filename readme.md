# Readme
PostgreSQL related database application which will load those daily spreadsheets into the Postgres database.

Firstly I have a series of bash scripts which will load the CSV files into a staging table and then into an Atomic table.

Next we run various functions which will load data into temporary tables and run calculations, by grabbing the top x stocks, normally based on Weighted Alpha and using these stocks to work out the average for the next day.

There are seperate functions for daily, weekly and monthly.

