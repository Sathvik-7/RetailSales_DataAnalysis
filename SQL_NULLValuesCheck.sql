DECLARE @TableName NVARCHAR(100) = 'retail_sales';
DECLARE @SQL NVARCHAR(MAX) = '';
DECLARE @ColumnName NVARCHAR(100);

-- Build dynamic SQL to count NULLs per column
SELECT @SQL += '
SELECT ''' + COLUMN_NAME + ''' AS ColumnName, 
       COUNT(*) AS NullCount
FROM ' + QUOTENAME(@TableName) + '
WHERE ' + QUOTENAME(COLUMN_NAME) + ' IS NULL
HAVING COUNT(*) > 0
UNION ALL'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName;

-- Remove last UNION ALL
SET @SQL = LEFT(@SQL, LEN(@SQL) - 10);

-- Execute
EXEC sp_executesql @SQL;
