/**************************************************************************
	FK Index Generator
	Author: Eric Cobb - http://www.sqlnuggets.com/
	Source: https://github.com/ericcobb/FK-Index-Generator
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

SELECT [ParentSchema], [ParentTable], [ParentColumn],
		[Script] = 'CREATE NONCLUSTERED INDEX [IX_FK_'+[ParentTable]+'_'+[ParentColumn]+'] ON ['+[ParentSchema]+'].['+[ParentTable]+'] (['+[ParentColumn]+']);'
--Gets a list of all FK Constraints
FROM (SELECT [ParentObjectID] = fk.parent_object_id
			,[ParentSchema] = SCHEMA_NAME (fk.[schema_id])
			,[ParentTable] = t.[name]
			,[parent_column_id] = fkc.parent_column_id
			,[ParentColumn] = COL_NAME(fk.parent_object_id , fkc.parent_column_id)
		FROM sys.foreign_keys fk
		INNER JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.[object_id]
		INNER JOIN sys.tables t ON t.object_id = fk.parent_object_id)  c
--Gets a list of the first key column of all nonclustered indexes
LEFT JOIN (SELECT [TableObjectID] = t.[object_id]
					,[IndexName] = i.[name]
					,[TableColumnID] = ic.column_id
			FROM sys.indexes i
			INNER JOIN sys.index_columns ic ON ic.object_id = i.object_id and ic.index_id = i.index_id
			INNER JOIN sys.tables t ON t.object_id = i.object_id 
			INNER JOIN sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
			WHERE i.[type] IN (1,2)
			AND OBJECTPROPERTY(i.OBJECT_ID,'IsUserTable') = 1
			AND ic.key_ordinal = 1) i ON i.[TableObjectID] = c.[ParentObjectID] AND i.[TableColumnID] = c.parent_column_id
WHERE i.[IndexName] IS NULL  --If NULL, an index beginning with the specified key column does not exist.
ORDER BY [ParentSchema], [ParentTable], [ParentColumn];
