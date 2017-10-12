# FK Index Generator
A basic script that generates nonclustered indexes to support existing Foreign Key constraints in a SQL Server database.

This query works as follows:
First, it pulls a list of all FK constraints currently in the database;
Second, it pulls a list of the first key column of each Clustered and Nonclustered Index in the database;
Third, it mashes the two result sets together to find which FK Constraints do not have indexes that can support them, and generates the CREATE NONCLUSTERED INDEX script;
