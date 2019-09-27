/**************************************************************************
	Find Queries With Missing Index Requests
	Author: Eric Cobb - http://www.sqlnuggets.com/blog/sql-scripts-find-queries-that-have-missing-index-requests/
	Source: https://github.com/ericcobb/SQL-Server-Index-Insight-Scripts
	Supported Versions: SQL Server 2008, SQL Server 2012, SQL Server 2014, SQL Server 2016, SQL Server 2017
	License:
			MIT License
			
			Copyright (c) 2017 Eric Cobb
			Permission is hereby granted, free of charge, to any person obtaining a copy
			of this software and associated documentation files (the "Software"), to deal
			in the Software without restriction, including without limitation the rights
			to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
			copies of the Software, and to permit persons to whom the Software is
			furnished to do so, subject to the following conditions:
			The above copyright notice and this permission notice shall be included in all
			copies or substantial portions of the Software.
			THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
			IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
			FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
			AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
			LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
			OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
			SOFTWARE.
			
	Usage:	
			Modify the '[YourDatabaseName]' AND '[YourTableName]' values in the WHERE clause at the end of the query

***************************************************************************/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
 
WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
, PlanMissingIndexes
AS (SELECT query_plan, usecounts
    FROM sys.dm_exec_cached_plans cp
    CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) qp
    WHERE qp.query_plan.exist('//MissingIndexes') = 1)
, MissingIndexes
AS (SELECT stmt_xml.value('(QueryPlan/MissingIndexes/MissingIndexGroup/MissingIndex/@Database)[1]', 'sysname') AS DatabaseName,
           stmt_xml.value('(QueryPlan/MissingIndexes/MissingIndexGroup/MissingIndex/@Schema)[1]', 'sysname') AS SchemaName,
           stmt_xml.value('(QueryPlan/MissingIndexes/MissingIndexGroup/MissingIndex/@Table)[1]', 'sysname') AS TableName,
           stmt_xml.value('(QueryPlan/MissingIndexes/MissingIndexGroup/@Impact)[1]', 'float') AS Impact,
           ISNULL(CAST(stmt_xml.value('(@StatementSubTreeCost)[1]', 'VARCHAR(128)') AS FLOAT), 0) AS Cost,
           pmi.usecounts UseCounts,
           STUFF((SELECT DISTINCT ', ' + c.value('(@Name)[1]', 'sysname')
		FROM stmt_xml.nodes('//ColumnGroup') AS t(cg)
		CROSS APPLY cg.nodes('Column') AS r(c)
		WHERE cg.value('(@Usage)[1]', 'sysname') = 'EQUALITY'
		FOR XML PATH('')),1,2,''
                ) AS equality_columns,
           STUFF(( SELECT DISTINCT ', ' + c.value('(@Name)[1]', 'sysname')
		FROM stmt_xml.nodes('//ColumnGroup') AS t(cg)
		CROSS APPLY cg.nodes('Column') AS r(c)
		WHERE cg.value('(@Usage)[1]', 'sysname') = 'INEQUALITY'
		FOR XML PATH('')),1,2,''
                ) AS inequality_columns,
           STUFF((SELECT DISTINCT ', ' + c.value('(@Name)[1]', 'sysname')
		FROM stmt_xml.nodes('//ColumnGroup') AS t(cg)
		CROSS APPLY cg.nodes('Column') AS r(c)
		WHERE cg.value('(@Usage)[1]', 'sysname') = 'INCLUDE'
		FOR XML PATH('')),1,2,''
                ) AS include_columns,
           query_plan,
           stmt_xml.value('(@StatementText)[1]', 'varchar(4000)') AS sql_text
    FROM PlanMissingIndexes pmi
    CROSS APPLY query_plan.nodes('//StmtSimple') AS stmt(stmt_xml)
    WHERE stmt_xml.exist('QueryPlan/MissingIndexes') = 1)
 
SELECT TOP 200
       DatabaseName,
       SchemaName,
       TableName,
       equality_columns,
       inequality_columns,
       include_columns,
       UseCounts,
       Cost,
       Cost * UseCounts [AggregateCost],
       Impact,
       query_plan
FROM MissingIndexes
WHERE DatabaseName = '[YourDatabaseName]' AND TableName = '[YourTableName]'
ORDER BY Cost * UseCounts DESC;

