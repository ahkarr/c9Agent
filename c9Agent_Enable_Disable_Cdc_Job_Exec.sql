-- enable database level
USE [c9Agent]
EXEC sys.sp_cdc_enable_db;

-- enable table level
USE [c9Agent]
Go
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'WORKFLOW_EXEC',
@role_name = N'dbo',
@supports_net_changes = 1

USE [c9Agent]
Go
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'LOG_HTTP_RESPONSE',
@role_name = N'dbo',
@supports_net_changes = 1

USE [c9Agent]
Go
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'OUTCOME_MESSAGE_QUEUE',
@role_name = N'dbo',
@supports_net_changes = 1

USE [c9Agent]
Go
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'INCOME_MESSAGE_QUEUE',
@role_name = N'dbo',
@supports_net_changes = 1

USE [c9Agent]
Go
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'LOG_EVENT',
@role_name = N'dbo',
@supports_net_changes = 1

USE [c9Agent]
Go
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'LOG_HTTP_REQUEST',
@role_name = N'dbo',
@supports_net_changes = 1

USE [c9Agent]
Go
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'LOG_API',
@role_name = N'dbo',
@supports_net_changes = 1

USE [c9Agent]
Go
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'AGENT_BATCH_EXEC',
@role_name = N'dbo',
@supports_net_changes = 1

USE [c9Agent]
Go
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'AGENT_SERVICE_EXEC',
@role_name = N'dbo',
@supports_net_changes = 1

Use [c9Agent]
Go

Select 'EXEC sys.sp_cdc_disable_table
 @source_schema = ''' + OBJECT_SCHEMA_NAME (source_object_id) +''',
 @source_name = ''' + object_name(source_object_id)+ ''',
 @capture_instance = '''+ capture_instance +''';',* From cdc.change_tables

 EXEC sys.sp_cdc_disable_table   @source_schema = 'dbo',   @source_name = 'OUTCOME_MESSAGE_QUEUE',   @capture_instance = 'dbo_OUTCOME_MESSAGE_QUEUE';
EXEC sys.sp_cdc_disable_table   @source_schema = 'dbo',   @source_name = 'INCOME_MESSAGE_QUEUE',   @capture_instance = 'dbo_INCOME_MESSAGE_QUEUE';
EXEC sys.sp_cdc_disable_table   @source_schema = 'dbo',   @source_name = 'LOG_EVENT',   @capture_instance = 'dbo_LOG_EVENT';
EXEC sys.sp_cdc_disable_table   @source_schema = 'dbo',   @source_name = 'LOG_HTTP_REQUEST',   @capture_instance = 'dbo_LOG_HTTP_REQUEST';
EXEC sys.sp_cdc_disable_table   @source_schema = 'dbo',   @source_name = 'LOG_API',   @capture_instance = 'dbo_LOG_API';
EXEC sys.sp_cdc_disable_table   @source_schema = 'dbo',   @source_name = 'AGENT_SERVICE_EXEC',   @capture_instance = 'dbo_AGENT_SERVICE_EXEC';
EXEC sys.sp_cdc_disable_table   @source_schema = 'dbo',   @source_name = 'WORKFLOW_EXEC',   @capture_instance = 'dbo_WORKFLOW_EXEC';
EXEC sys.sp_cdc_disable_table   @source_schema = 'dbo',   @source_name = 'LOG_HTTP_RESPONSE',   @capture_instance = 'dbo_LOG_HTTP_RESPONSE';
use [c9Agent]
EXEC sys.sp_cdc_disable_db


EXEC sys.sp_cdc_disable_table   @source_schema = 'dbo',   @source_name = 'WORKFLOW_EXEC',   @capture_instance = 'dbo_WORKFLOW_EXEC';