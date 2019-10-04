# Index Insight Scripts
A collection of scripts to use with indexes in SQL Server
## Find Index Fragmentation
As records are inserted, updated, and deleted, your tables and indexes become fragmented.  This query will provide a list of indexes, fragmentation percentage, and record counts for each table in a database.

For more details, see: http://www.sqlnuggets.com/blog/sql-scripts-find-index-fragmentation/
## Find Filtered Indexes
A simple query that will provide a list of filtered indexes, with the schema and table, as well as the actual filter used in the index.  It is database specific, so it will need to be run against every database you want to view filtered indexes on.

For more details, see: http://www.sqlnuggets.com/blog/sql-scripts-how-to-find-filtered-indexes/
## Find Missing Index Requests
This query will show missing index suggestions for the specified database.  You can also narrow it down to a specified table by un-commenting the AND statement and specifying the table name.  This script also generates a CREATE INDEX script for each record, so that you can take a better look at the index and decide if you want to use it.

For more details, see: http://www.sqlnuggets.com/blog/sql-scripts-how-to-find-missing-indexes/
## Find Missing Index Request Queries
This script will show the queries that generated the missing index requests (should be used in conjunction with the Find Missing Index Requests script).  It will get any available execution plans that have a *MissingIndexes* element. Once the execution plan is recovered, the script parses through the XML of the plan to retrieve the database, schema, and table names, as well as the columns recommended in the index, and the cost and impact associated with the recommended index. It also retrieves the execution plan so that you can open it up and see the exact t-sql query that requested the index.

For more details, see: http://www.sqlnuggets.com/blog/sql-scripts-find-queries-that-have-missing-index-requests/
## FK Index Generator
A basic script that generates nonclustered indexes to support existing Foreign Key constraints in a SQL Server database.

This query works as follows:
- First, it pulls a list of all FK constraints currently in the database;
- Second, it pulls a list of the first key column of each Clustered and Nonclustered Index in the database;
- Third, it mashes the two result sets together to find which FK Constraints do not have indexes that can support them, and generates the CREATE NONCLUSTERED INDEX script;
