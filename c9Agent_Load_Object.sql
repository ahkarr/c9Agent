Use [c9Agent]
Go

CREATE TABLE [dbo].[SERVICE](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	ServiceCode VARCHAR(5),
	ServiceName VARCHAR(50),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[INSTANCE](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	ServiceCode VARCHAR(5),
	InstanceBody VARCHAR(50),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[GRPC](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	ServiceCode VARCHAR(5),
	GrpcLink VARCHAR(50),
	GrpcPort INT,
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[ENVIRONMENT](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	ServiceCode VARCHAR(5),
	ServiceLink VARCHAR(50),
	ServicePort INT,
	DatabaseLink VARCHAR(50),
	DatabasePort INT,
	ApiLink VARCHAR(50),
	ApiPort INT,
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[EVENT](
	Id INT IDENTITY(1,1),
	EventId VARCHAR(50) PRIMARY KEY,
	ServiceId VARCHAR(50),
	ServiceCode VARCHAR(5),
	EventCode VARCHAR(10),
	EventBody VARCHAR(50),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[CONFIGURATION](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	ServiceCode VARCHAR(5),
	ConfigKey VARCHAR(10),
	ConfigBody VARCHAR(50),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[USER](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	ServiceCode VARCHAR(5),
	UserCode VARCHAR(10),
	UserName VARCHAR(50),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[INCOME_MESSAGE_QUEUE](
	Id INT IDENTITY(1,1),
	RefId VARCHAR(50) PRIMARY KEY,
	MessageBody VARCHAR(MAX),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[OUTCOME_MESSAGE_QUEUE](
	Id INT IDENTITY(1,1),
	RefId VARCHAR(50) PRIMARY KEY,
	MessageBody VARCHAR(MAX),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[WORKFLOW](
	Id INT IDENTITY(1,1),
	WfId VARCHAR(50) PRIMARY KEY,
	WfBody VARCHAR(200),
	ServiceId VARCHAR(50),
	ServiceCode VARCHAR(5),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[WORKFLOW_EXEC](
	Id INT IDENTITY(1,1),
	RefId VARCHAR(50) PRIMARY KEY,
	WfBody VARCHAR(MAX),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[WORKFLOW_EXEC_LOG](
	Id INT IDENTITY(1,1) PRIMARY KEY,
	RefId VARCHAR(50),
	WfBody VARCHAR(MAX),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME,
	PurgedOnUtc DATETIME
);

CREATE TABLE [dbo].[LOG_API](
	Id INT IDENTITY(1,1),
	RefId VARCHAR(50) PRIMARY KEY,
	ApiExecuteBody VARCHAR(200),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[LOG_EVENT](
	Id INT IDENTITY(1,1),
	RefId VARCHAR(50) PRIMARY KEY,
	EventExecuteBody VARCHAR(MAX),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);


CREATE TABLE [dbo].[LOG_HTTP_REQUEST](
	Id INT IDENTITY(1,1),
	RefId VARCHAR(50) PRIMARY KEY,
	HttpRequestBody VARCHAR(MAX),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[LOG_HTTP_RESPONSE](
	Id INT IDENTITY(1,1),
	RefId VARCHAR(50) PRIMARY KEY,
	HttpResponseBoy VARCHAR(MAX),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[LOG_HTTP_MESSAGE](
	Id INT IDENTITY(1,1),
	RefId VARCHAR(50) PRIMARY KEY,
	MessageExecuteBody VARCHAR(MAX),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[ORGANIZATION](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	ServiceCode VARCHAR(5),
	Organization VARCHAR(100),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[API](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	ServiceCode VARCHAR(5),
	ApiBody VARCHAR(100),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[AGENT](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	ServiceCode VARCHAR(5),
	AgentName VARCHAR(100),
	AgentCode VARCHAR(10),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[STATIC_TOKEN](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	PublicToken VARCHAR(50),
	PrivateToken VARCHAR(50),
	PublicEncryptKey VARBINARY(100),
	PrivateEncryptKey VARBINARY(100),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[MFA_CONFIGURATION](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	PublicToken VARCHAR(50),
	PrivateToken VARCHAR(50),
	PublicEncryptKey VARBINARY(100),
	PrivateEncryptKey VARBINARY(100),
	ServiceProvider VARCHAR(10),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[AUTH_USER](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	ServiceProvider VARCHAR(50),
	AuthKey VARCHAR(50),
	AuthEncyptKey VARBINARY(100),
	ServiceBody VARCHAR(100),
	ServiceConnector VARCHAR(100),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[AUTH_ROLE_DEF](
	Id INT IDENTITY(1,1),
	RoleId VARCHAR(50) PRIMARY KEY,
	RoleDesc VARCHAR(50),
	ServiceType VARCHAR(20),
	ServiceCode VARCHAR(5),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[ENVIRONMENT_VARIABLE](
	Id INT IDENTITY(1,1),
	VarRefId VARCHAR(50) PRIMARY KEY,
	VariableKey VARCHAR(50),
	Variable VARCHAR(200),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[MAPPING_DICTIONARY](
	Id INT IDENTITY(1,1),
	MappingId VARCHAR(50) PRIMARY KEY,
	Ref1 VARCHAR(50),
	Val1 VARCHAR(100),
	Ref2 VARCHAR(50),
	Val2 VARCHAR(100),
	Ref3 VARCHAR(50),
	Val3 VARCHAR(100),
	Ref4 VARCHAR(50),
	Val4 VARCHAR(100),
	CreatedAt DATETIME,
	UpdatedAt DATETIME
);

CREATE TABLE [dbo].[TEMPLATE](
	Id INT IDENTITY(1,1),
	TemplateId VARCHAR(50) PRIMARY KEY,
	TemplateBody VARCHAR(MAX),
	ServiceId VARCHAR(50),
	CreatedAt DATETIME,
	UpdatedAt DATETIME
);

CREATE TABLE [dbo].[AGENT_TOKEN](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	PublicToken VARCHAR(50),
	PrivateToken VARCHAR(50),
	PublicEncryptKey VARBINARY(100),
	PrivateEncryptKey VARBINARY(100),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[AGENT_SERVICE_EXEC](
	Id INT IDENTITY(1,1),
	ExecRef VARCHAR(50) PRIMARY KEY,
	ExecuteBody VARCHAR(100),
	WorkflowBody VARCHAR(MAX),
	IS_COMPLETE VARCHAR(2),
	IS_TIMEOUT VARCHAR(2),
	UserExecute VARCHAR(30),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[AGENT_SERVICE_EXEC_LOG](
	Id INT IDENTITY(1,1),
	ExecRef VARCHAR(50),
	ExecuteBody VARCHAR(100),
	WorkflowBody VARCHAR(100),
	IS_COMPLETE VARCHAR(2),
	IS_TIMEOUT VARCHAR(2),
	UserExecute VARCHAR(30),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME,
	PurgedOnUtc DATETIME
);

CREATE TABLE [dbo].[AGENT_BATCH_INSTANCE](
	Id INT IDENTITY(1,1),
	ServiceId VARCHAR(50),
	AgentId VARCHAR(50),
	BatchInstance VARCHAR(100),
	BatchBody VARCHAR(100),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[AGENT_BATCH_EXEC](
	Id INT IDENTITY(1,1),
	ExecuteRef VARCHAR(100),
	ExecuteBatch VARCHAR(MAX),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME,
	ExecuteDate DATETIME
);

CREATE TABLE [dbo].[AGENT_CONFIGURATION](
	Id INT IDENTITY(1,1) PRIMARY KEY,
	ConfigCode VARCHAR(10),
	ConfigValue VARCHAR(50),
	ConfigType VARCHAR(10),
	ConfigGroup VARCHAR(5),
	ConfigStatus VARCHAR(1),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE [dbo].[ROLE_PERMISSION](
	Id INT IDENTITY(1,1),
	RoleId VARCHAR(15) PRIMARY KEY,
	ServiceCode VARCHAR(5),
	IsInit VARCHAR(1),
	IsAuth VARCHAR(1),
	IsServiceConnect VARCHAR(1),
	IsServiceDisconnect VARCHAR(1),
	IsExecute VARCHAR(1),
	IsReverse VARCHAR(1),
	IsTimeoutAllow VARCHAR(1),
	AllowBatch VARCHAR(1),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
)

Create Table [dbo].[AGENT_AUDITLOG](
	Id INT IDENTITY(1,1) NOT NULL,
	LogRef VARCHAR(50),
	DatabaseName VARCHAR(10),
	SchemaName VARCHAR(5),
	TableName VARCHAR(50),
	DataRowCount INT,
	LogExecutedOnUtc DATETIME,
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME,
);

Create Table [dbo].[AGENT_JOB](
	Id INT IDENTITY(1,1) NOT NULL,
	JobId VARCHAR(50),
	JobName VARCHAR(100),
	VersionNumber INT,
	DateCreated DATETIME,
	DateModified DATETIME,
	DatePurged DATETIME,
);

Create Table [dbo].[AGENT_JOBSTEP](
	Id INT IDENTITY(1,1) NOT NULL,
	JobId VARCHAR(50),
	StepId INT,
	StepName VARCHAR(100),
	StepCommand VARCHAR(MAX),
	LastRunDate INT,
	LastRunTime INT,
	DatePurged DATETIME,
);

CREATE TABLE [dbo].[AGENT_DATATABLE](
	[TypeRef] [varchar](40) NULL,
	[SchemaName] [sysname] NOT NULL,
	[TableName] [sysname] NOT NULL,
	[ColumnName] [sysname] NULL,
	[DataTypeName] [sysname] NOT NULL,
	[max_length] [smallint] NOT NULL,
	[precision] [tinyint] NOT NULL,
	[scale] [tinyint] NOT NULL,
	[is_nullable] [bit] NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUTc] [int] NULL
);

CREATE TABLE [dbo].[AGENT_DICTIONARY](
	[Table Name] [nvarchar](257) NULL,
	[Check Constraint] [nvarchar](max) NOT NULL,
	[Column Name] [sysname] NULL,
	[Data type] [nvarchar](128) NULL,
	[Max Length (Bytes)] [smallint] NOT NULL,
	[Is Computed] [varchar](3) NOT NULL,
	[Is Persisted] [varchar](3) NOT NULL,
	[Is Nullable] [varchar](3) NULL,
	[Default Value] [nvarchar](4000) NOT NULL,
	[Description] [sql_variant] NOT NULL,
	[Foreign Key Constraint] [nvarchar](531) NOT NULL,
	[Primary Key Constraint] [nvarchar](max) NULL
);

CREATE TABLE AGENT_ADMIN(
	Id INT NOT NULL IDENTITY(1,1),
	ServiceId VARCHAR(50) PRIMARY KEY,
	ServiceCode VARCHAR(3),
	AgentCode VARCHAR(10),
	AgentName VARCHAR(50),
	AgentEmail VARCHAR(20),
	Phone VARCHAR(10),
	OrganizatioUrl VARCHAR(MAX),
	ProfileUrl VARCHAR(MAX),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);

CREATE TABLE SERVICE_VARIABLE(
	Id INT NOT NULL IDENTITY(1,1),
	VarRefNo VARCHAR(50),
	DatabaseId VARCHAR(20),
	DatabaseName VARCHAR(30),
	ConfigBody NVARCHAR(MAX),
	DataBody NVARCHAR(MAX),
	Ref1 NVARCHAR(MAX),
	Val1 NVARCHAR(MAX),
	Rel2 NVARCHAR(MAX),
	Val2 NVARCHAR(MAX),
	Ref3 NVARCHAR(MAX),
	Val3 NVARCHAR(MAX),
	Ref4 NVARCHAR(MAX),
	Val4 NVARCHAR(MAX),
	Ref5 NVARCHAR(MAX),
	Val5 NVARCHAR(MAX),
	CreatedOnUtc DATETIME,
	UpdatedOnUtc DATETIME
);



































