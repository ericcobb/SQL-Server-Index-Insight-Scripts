/**************************************************************************
	FK Index Generator
	Author: Eric Cobb - http://www.sqlnuggets.com/
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
USE YourDB
GO

SELECT [SchemaName] = s.[Name]
		,[TableName] = t.[Name]
		,[IndexName] = i.[Name]
		,[IndexType] = i.[type_desc]
		,[Filter] = i.filter_definition
FROM sys.indexes i
INNER JOIN sys.tables t ON t.object_id = i.object_id
INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE t.type_desc = N'USER_TABLE'
AND i.has_filter = 1

