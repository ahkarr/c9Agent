-- J_LOG_API_EXEC
Use [c9Agent]
Go

DECLARE @COUNT INT
SET @COUNT = 0
WHILE ( @COUNT < (Select ROUND(Rand(),1)*500))
BEGIN
Begin Tran;
Insert Into dbo.LOG_API (RefId,ApiExecuteBody,CreatedOnUtc,UpdatedOnUtc)
Values
(
Lower(NewId()),
(Select TOP 1 ApiBody From dbo.API Order By NEWID()),
GETDATE(),
NULL
)
Commit Tran;
SET @COUNT = @COUNT + 1 
END

-- J_LOG_EVT_EXEC
Use [c9Agent]
Go

DECLARE @COUNT INT
SET @COUNT = 0
WHILE ( @COUNT < (Select ROUND(Rand(),1)*500))
BEGIN
Begin Tran;
Insert Into dbo.LOG_EVENT(RefId,EventExecuteBody,CreatedOnUtc,UpdatedOnUtc)
Values
(
Lower(NewId()),
(Select TOP 1 EventBody,EventCode,ServiceCode From dbo.EVENT Order By NEWID() FOR JSON PATH),
GETDATE(),
NULL
)
Commit Tran;
SET @COUNT = @COUNT + 1 
END

-- J_LOG_HTP_MSG_EXEC
Use [c9Agent]
Go

DECLARE @COUNT INT
SET @COUNT = 0
WHILE ( @COUNT < (Select ROUND(Rand(),1)*500))
BEGIN
Begin Tran;
Insert Into dbo.LOG_HTTP_MESSAGE(RefId,MessageExecuteBody,CreatedOnUtc,UpdatedOnUtc)
Values
(
Lower(NewId()),
(Select LOWER(NEWID()) MsgBdy,LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),20,14)) MsgKey FOR JSON PATH),
GETDATE(),
NULL
)
Commit Tran;
SET @COUNT = @COUNT + 1 
END

-- J_LOG_HTP_REQ_EXEC
Use [c9Agent]
Go

DECLARE @COUNT INT
SET @COUNT = 0
WHILE ( @COUNT < (Select ROUND(Rand(),1)*500))
BEGIN
Begin Tran;
Insert Into dbo.LOG_HTTP_REQUEST(RefId,HttpRequestBody,CreatedOnUtc,UpdatedOnUtc)
Values
(
Lower(NewId()),
(Select LOWER(NEWID()) ReqBdy,LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),20,14)) ReqKey FOR JSON PATH),
GETDATE(),
NULL
)
Commit Tran;
SET @COUNT = @COUNT + 1 
END

-- J_LOG_HTP_RSP_EXEC
Use [c9Agent]
Go

DECLARE @COUNT INT
SET @COUNT = 0
WHILE ( @COUNT < (Select ROUND(Rand(),1)*500))
BEGIN
Begin Tran;
Insert Into dbo.LOG_HTTP_RESPONSE(RefId,HttpResponseBoy,CreatedOnUtc,UpdatedOnUtc)
Values
(
Lower(NewId()),
(Select LOWER(NEWID()) RspBdy,LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),20,14)) RspKey FOR JSON PATH),
GETDATE(),
NULL
)
Commit Tran;
SET @COUNT = @COUNT + 1 
END

-- J_INC_MSG_QUE_EXEC
Use [c9Agent]
Go

DECLARE @COUNT INT
SET @COUNT = 0
WHILE ( @COUNT < (Select ROUND(Rand(),1)*500))
BEGIN
Begin Tran;
Insert Into dbo.INCOME_MESSAGE_QUEUE(RefId,MessageBody,CreatedOnUtc,UpdatedOnUtc)
Values
(
Lower(NewId()),
(Select LOWER(NEWID()) MsgBdy,LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),20,14)) Msgkey FOR JSON PATH),
GETDATE(),
NULL
)
Commit Tran;
SET @COUNT = @COUNT + 1 
END

-- J_OUT_MSG_QUE_EXEC
Use [c9Agent]
Go

DECLARE @COUNT INT
SET @COUNT = 0
WHILE ( @COUNT < (Select ROUND(Rand(),1)*500))
BEGIN
Begin Tran;
Insert Into dbo.OUTCOME_MESSAGE_QUEUE(RefId,MessageBody,CreatedOnUtc,UpdatedOnUtc)
Values
(
Lower(NewId()),
(Select LOWER(NEWID()) MsgBdy,LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),20,14)) Msgkey FOR JSON PATH),
GETDATE(),
NULL
)
Commit Tran;
SET @COUNT = @COUNT + 1 
END

-- J_WFD_BDY_EXEC
Use [c9Agent]
Go

DECLARE @COUNT INT
SET @COUNT = 0
WHILE ( @COUNT < (Select ROUND(Rand(),1)*500))
BEGIN
Begin Tran;
Insert Into dbo.WORKFLOW_EXEC(RefId,WfBody,CreatedOnUtc,UpdatedOnUtc)
Values
(
Lower(NewId()),
(Select TOP 1 WfId,WfBody,ServiceId,ServiceCode From dbo.WORKFLOW ORDER BY NEWID() FOR JSON PATH),
GETDATE(),
NULL
)
Commit Tran;
SET @COUNT = @COUNT + 1 
END

-- J_AGT_BTH_EXEC
Use [c9Agent]
Go

DECLARE @COUNT INT
SET @COUNT = 0
WHILE ( @COUNT < (Select ROUND(Rand(),1)*10))
BEGIN
Begin Tran;
Insert Into dbo.AGENT_BATCH_EXEC(ExecuteRef,ExecuteBatch,CreatedOnUtc,UpdatedOnUtc,ExecuteDate)
Values
(
Lower(NewId()),
(Select TOP 1 ServiceId,BatchInstance From dbo.AGENT_BATCH_INSTANCE ORDER BY NEWID() FOR JSON PATH),
GETDATE(),
NULL,
GETDATE()
)
Commit Tran;
SET @COUNT = @COUNT + 1 
END

-- J_AGT_SRV_EXEC
Use [c9Agent]
Go

DECLARE @COUNT INT
SET @COUNT = 0
WHILE ( @COUNT < (Select ROUND(Rand(),1)*10))
BEGIN
Begin Tran;
Insert Into dbo.AGENT_SERVICE_EXEC(ExecRef,ExecuteBody,WorkflowBody,IS_COMPLETE,IS_TIMEOUT,UserExecute,CreatedOnUtc,UpdatedOnUtc)
Values
(
Lower(NewId()),
(Select LOWER(NEWID()) ExecutionNumber FOR JSON PATH),
(Select TOP 1 ServiceCode,ServiceId,WfId,WfBody From dbo.WORKFLOW ORDER BY NEWID() FOR JSON PATH),
(Select TOP 1 ConfigCode From dbo.AGENT_CONFIGURATION WHERE ConfigType = 'CSTS' ORDER BY NEWID()),
(Select TOP 1 ConfigCode From dbo.AGENT_CONFIGURATION WHERE ConfigType = 'TSTS' ORDER BY NEWID()),
(Select ConfigCode From dbo.AGENT_CONFIGURATION WHERE ConfigType = 'AGTUSR'),
GETDATE(),
NULL
)
Commit Tran;
SET @COUNT = @COUNT + 1 
END

-- J_AGT_ADT_LOG_EXEC

Use [c9Agent]
Go
BEGIN TRAN;
-- Truncate Table dbo.AGENT_AUDITLOG
Insert Into dbo.AGENT_AUDITLOG
Select LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),10,14)),'c9Agent' [Database],'dbo' [Schema],A.name [TableName],B.rows [RowCount],GETDATE(),GETDATE(),NULL From 
sys.sysobjects A Join sys.sysindexes B
On A.id = B.id
And B.indid In (0,1)
And A.xtype = 'U'
Order By B.rows Desc
COMMIT TRAN;

-- J_AGT_DAT_TBL_EXCE
Use [c9Agent]
Go

BEGIN TRAN;
--DROP TABLE dbo.AGENT_DATATABLE
-- AGENT_DATATABLE
Insert Into dbo.[AGENT_DATATABLE]
	SELECT
	Lower(NEWID()) TypeRef,
	schemas.name AS SchemaName,
	tables.name AS TableName,
	columns.name AS ColumnName,
	types.name AS DataTypeName,
	columns.max_length,
	columns.precision,
	columns.scale,
	columns.is_nullable,
	GETDATE() CreatedOnUtc,
	NULL UpdatedOnUTc
FROM sys.tables
INNER JOIN sys.columns
ON tables.object_id = columns.object_id
INNER JOIN sys.types
ON types.user_type_id = columns.user_type_id
INNER JOIN sys.schemas
ON schemas.schema_id = tables.schema_id
WHERE tables.is_ms_shipped = 0;

COMMIT TRAN;

-- J_AGT_DATA_DICT_EXCE
Use [c9Agent]
Go

BEGIN TRAN;
--DROP TABLE dbo.AGENT_DICTIONARY
USE [c9Agent]
GO

WITH CTE_COLUMN_INFO_AND_CHECK_CONSTRAINTS
AS
(
	-- This Select Statement retrieves all the data about the Columns in my DB + Check Constraints
	SELECT DISTINCT
		SCHEMA_NAME(st.[schema_id]) + '.' + st.[name] AS [Table Name],
		ISNULL(con.[definition], '') AS [Check Constraint],
		sc.[name] AS [Column Name],			
		isc.DATA_TYPE AS [Data type],
		sc.max_length AS [Max Length (Bytes)],
		CASE WHEN sc.is_computed = 1 THEN 'YES' ELSE 'NO' END AS [Is Computed],
		CASE WHEN syscc.is_persisted = 1 THEN 'YES' ELSE 'NO' END AS [Is Persisted],
		isc.IS_NULLABLE AS [Is Nullable],
		ISNULL(isc.COLUMN_DEFAULT, '') AS [Default Value],
		ISNULL(ep.[value], 'N/A') AS [Description]		
	FROM sys.tables st	
	INNER JOIN sys.columns sc 
		ON st.[object_id]=sc.[object_id]
	INNER JOIN information_schema.columns isc 
		ON sc.[name]= isc.COLUMN_NAME AND st.[name]=isc.TABLE_NAME															
	LEFT JOIN sys.extended_properties ep 
		ON  st.[object_id]=ep.major_id AND sc.column_id=ep.minor_id AND ep.[name]='MS_Description'					
	LEFT OUTER JOIN sys.check_constraints con 
		ON con.parent_column_id = sc.column_id AND con.parent_object_id = sc.[object_id]
	LEFT JOIN sys.computed_columns AS syscc 
		ON syscc.object_id = sc.object_id AND syscc.[name] = sc.[name]
)
, CTE_FOREIGN_KEYS
AS
(
	-- This Select Statement retrieves all the data about the Foreign Keys in my DB
	SELECT 
		pk_tab.[object_id],
		SCHEMA_NAME(fk_tab.[schema_id]) + '.' + fk_tab.[name] AS foreign_table,        		
        	'Foreign key' AS [Foreign Key],
        	fk.[name] AS fk_constraint_name,		
		COL_NAME(fk_cols.parent_object_id,fk_cols.parent_column_id) + 
		' references ' + 
		COL_NAME(fk_cols.referenced_object_id,fk_cols.referenced_column_id) + 
		' from ' +
		SCHEMA_NAME(pk_tab.[schema_id]) + '.' +  pk_tab.[name] AS Details,
		COL_NAME(fk_cols.referenced_object_id,fk_cols.referenced_column_id) AS ColumnName
    FROM sys.foreign_keys fk
    INNER JOIN sys.tables fk_tab
        ON fk_tab.[object_id] = fk.parent_object_id
    INNER JOIN sys.tables pk_tab
        ON pk_tab.[object_id] = fk.referenced_object_id
    INNER JOIN sys.foreign_key_columns fk_cols
        ON fk_cols.constraint_object_id = fk.[object_id]
)
, CTE_PRIMARY_KEYS
AS
(
	-- This Select Statement retrieves all the data about the Primary Keys in my DB
	SELECT 
		t.[object_id],
		SCHEMA_NAME(t.[schema_id]) + '.' + t.[name] AS table_view,        
		c.[type] AS [Primery Key],
		ISNULL(c.[name], i.[name]) AS constraint_name,
		SUBSTRING(column_names, 1, LEN(column_names)-1) AS [details]
	FROM sys.objects t
	LEFT OUTER JOIN sys.indexes i
		ON t.[object_id] = i.[object_id]
	LEFT OUTER JOIN sys.key_constraints c
		ON i.[object_id] = c.parent_object_id AND i.index_id = c.unique_index_id
	CROSS APPLY 
	(
		SELECT col.[name] + ', '
		FROM sys.index_columns ic
		INNER JOIN sys.columns col
			ON ic.[object_id] = col.[object_id] AND ic.column_id = col.column_id
		WHERE ic.[object_id] = t.[object_id] AND ic.index_id = i.index_id
		ORDER BY col.column_id
		FOR XML PATH ('') 
	) D (column_names)
	WHERE is_unique = 1
	AND t.is_ms_shipped <> 1
)
	Insert 	INTO dbo.AGENT_DICTIONARY
	SELECT 
	CICC.*, 
	ISNULL(FKT.Details,'') AS [Foreign Key Constraint],
	PKT.details AS [Primary Key Constraint] 

FROM  CTE_COLUMN_INFO_AND_CHECK_CONSTRAINTS CICC
LEFT OUTER JOIN CTE_FOREIGN_KEYS FKT 
	ON CICC.[Column Name]=FKT.ColumnName AND CICC.[Table Name]=FKT.foreign_table
INNER JOIN CTE_PRIMARY_KEYS PKT 
	ON CICC.[Table Name]=PKT.table_view
COMMIT TRAN;


-- J_AGT_JOB_EXEC
Use [c9Agent]
Go
Begin Tran;
Insert Into dbo.AGENT_JOB
Select job_id,name,version_number,date_created,date_modified,getdate() From msdb.dbo.sysjobs
Where name like 'B%'
Commit Tran;

-- J_AGT_JOB_STEP_EXEC
Use [c9Agent]
Go
Begin Tran;
Insert Into dbo.AGENT_JOBSTEP
Select job_id,step_id,step_name,command,last_run_date,last_run_time,getdate()  From msdb.dbo.sysjobsteps
Where step_name like 'J%'
Commit Tran;
