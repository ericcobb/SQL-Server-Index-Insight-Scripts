
/**************************************************************************
	Find Index Fragmentation
	Author: Eric Cobb - http://www.sqlnuggets.com/blog/sql-scripts-find-index-fragmentation/
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
***************************************************************************/
USE YourDB --change this
GO
 
SELECT [table_name] = s.[name] +'.'+t.[name]  
 ,[index_name] = i.[NAME]
 ,index_type_desc
 ,[avg_fragmentation_in_percent] = ROUND(avg_fragmentation_in_percent,2)
 ,[table_record_count] = record_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') ips
INNER JOIN sys.tables t on t.[object_id] = ips.[object_id]
INNER JOIN sys.schemas s on t.[schema_id] = s.[schema_id]
INNER JOIN sys.indexes i ON (ips.object_id = i.object_id) AND (ips.index_id = i.index_id)
ORDER BY avg_fragmentation_in_percent DESC
 