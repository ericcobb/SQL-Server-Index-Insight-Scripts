# Index Insight Scripts
A collection of scripts to use with indexes in SQL Server
## Find Filtered Indexes
A simple query that will provide a list of filtered indexes, with the schema and table, as well as the actual filter used in the index.  It is database specific, so it will need to be run against every database you want to view filtered indexes on.
## FK Index Generator
A basic script that generates nonclustered indexes to support existing Foreign Key constraints in a SQL Server database.

This query works as follows:
- First, it pulls a list of all FK constraints currently in the database;
- Second, it pulls a list of the first key column of each Clustered and Nonclustered Index in the database;
- Third, it mashes the two result sets together to find which FK Constraints do not have indexes that can support them, and generates the CREATE NONCLUSTERED INDEX script;
