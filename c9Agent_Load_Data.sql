Use [c9Agent]
Go

Insert Into dbo.SERVICE (ServiceId,ServiceCode,ServiceName,CreatedOnUtc,UpdatedOnUtc)
Values
(LOWER(NEWID()),'ADM','Admin Service',GETDATE(),NULL),
(LOWER(NEWID()),'APP','Application Service',GETDATE(),NULL),
(LOWER(NEWID()),'AUT','Authentication Service',GETDATE(),NULL),
(LOWER(NEWID()),'BAT','Batch Service',GETDATE(),NULL),
(LOWER(NEWID()),'CTM','Customer Service',GETDATE(),NULL),
(LOWER(NEWID()),'PMT','Payment Service',GETDATE(),NULL),
(LOWER(NEWID()),'RPT','Report Service',GETDATE(),NULL),
(LOWER(NEWID()),'AGT','Agent Service',GETDATE(),NULL),
(LOWER(NEWID()),'JPT','Jupiter Service',GETDATE(),NULL);

Insert Into dbo.INSTANCE 
Select ServiceId,ServiceCode,LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),10,14)),GETDATE(),NULL From dbo.SERVICE

Insert Into dbo.GRPC
Select ServiceId,ServiceCode,CONCAT('http://localhost/',LOWER(ServiceCode),'/','grpc'),
CONCAT('50',SUBSTRING(CAST(ABS(CHECKSUM(NEWID())) AS nvarchar(max)),1,2)),GETDATE(),NULL From dbo.SERVICE

Insert Into dbo.ENVIRONMENT
Select ServiceId,ServiceCode,CONCAT('http://localhost/',LOWER(ServiceCode),'/'),
CONCAT('50',SUBSTRING(CAST(ABS(CHECKSUM(NEWID())) AS nvarchar(max)),1,2)),
CONCAT('192.168.110.',SUBSTRING(CAST(ABS(CHECKSUM(NEWID())) AS nvarchar(max)),1,2)),
CONCAT('14',SUBSTRING(CAST(ABS(CHECKSUM(NEWID())) AS nvarchar(max)),1,2)),
CONCAT('192.168.120.',SUBSTRING(CAST(ABS(CHECKSUM(NEWID())) AS nvarchar(max)),1,2)),
CONCAT('80',SUBSTRING(CAST(ABS(CHECKSUM(NEWID())) AS nvarchar(max)),1,2)),
GETDATE(),NULL From dbo.SERVICE

Insert Into dbo.EVENT
Select LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),10,14)),ServiceId,ServiceCode,'INIT',CONCAT('http://localhost/',LOWER(ServiceCode),'/','init'),GETDATE(),NULL From dbo.SERVICE
Union All
Select LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),10,14)),ServiceId,ServiceCode,'CONN',CONCAT('http://localhost/',LOWER(ServiceCode),'/','conn'),GETDATE(),NULL From dbo.SERVICE
Union All
Select LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),10,14)),ServiceId,ServiceCode,'EXEC',CONCAT('http://localhost/',LOWER(ServiceCode),'/','exec'),GETDATE(),NULL From dbo.SERVICE
Union All
Select LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),10,14)),ServiceId,ServiceCode,'DSCT',CONCAT('http://localhost/',LOWER(ServiceCode),'/','dsct'),GETDATE(),NULL From dbo.SERVICE
Union All
Select LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),10,14)),ServiceId,ServiceCode,'AUTH',CONCAT('http://localhost/',LOWER(ServiceCode),'/','auth'),GETDATE(),NULL From dbo.SERVICE
Order By ServiceCode

Insert Into dbo.CONFIGURATION
Select ServiceId,ServiceCode,LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),(Select LOWER(NEWID()) body FOR JSON PATH),GETDATE(),NULL 
From dbo.SERVICE

Insert Into dbo.[USER]
Select ServiceId,ServiceCode,Concat(LOWER(ServiceCode),'_adm'),Concat(ServiceName,' Administrator'),GETDATE(),NULL From dbo.SERVICE

Insert Into dbo.API
Select ServiceId,ServiceCode,Concat('{
  "X_API_VERSION": 1.0,
  "accept": "application/json"','"service":"',ServiceCode,'"',
'}'),GETDATE(),NULL From dbo.SERVICE

Insert Into dbo.ORGANIZATION
Select ServiceId,ServiceCode,Concat('http://localhost/c9agent/org/',Lower(ServiceCode)),GETDATE(),NULL From dbo.SERVICE

Insert Into dbo.AGENT
Select ServiceId,ServiceCode,CONCAT(ServiceName,' Agent'),Concat(ServiceCode,'-AGT'),GETDATE(),NULL From dbo.SERVICE

Insert Into dbo.STATIC_TOKEN
Select ServiceId,LOWER(NEWID()),LOWER(NEWID()),NULL,NULL,GETDATE(),NULL From dbo.SERVICE

Insert Into dbo.AGENT_TOKEN
Select ServiceId,LOWER(NEWID()),LOWER(NEWID()),NULL,NULL,GETDATE(),NULL From dbo.SERVICE

Insert Into dbo.MFA_CONFIGURATION
Select ServiceId,LOWER(NEWID()),LOWER(NEWID()),NULL,NULL,'Azure AD',GETDATE(),NULL From dbo.SERVICE

-- update static token

OPEN SYMMETRIC KEY c9Agt_Sym_Key
DECRYPTION BY CERTIFICATE c9Agt_Cert;
BEGIN TRAN
UPDATE c9Agent.dbo.STATIC_TOKEN
SET PublicEncryptKey = EncryptByKey (Key_GUID('c9Agt_Sym_Key'), PublicToken)
FROM c9Agent.dbo.STATIC_TOKEN;
GO
COMMIT TRAN
CLOSE SYMMETRIC KEY c9Agt_Sym_Key;
GO

OPEN SYMMETRIC KEY c9Agt_Sym_Key
DECRYPTION BY CERTIFICATE c9Agt_Cert;
BEGIN TRAN
UPDATE c9Agent.dbo.STATIC_TOKEN
SET PrivateEncryptKey = EncryptByKey (Key_GUID('c9Agt_Sym_Key'), PrivateToken)
FROM c9Agent.dbo.STATIC_TOKEN;
GO
COMMIT TRAN
CLOSE SYMMETRIC KEY c9Agt_Sym_Key;
GO


-- update mfa token

OPEN SYMMETRIC KEY c9Agt_Sym_Key
DECRYPTION BY CERTIFICATE c9Agt_Cert;
BEGIN TRAN
UPDATE c9Agent.dbo.MFA_CONFIGURATION
SET PublicEncryptKey = EncryptByKey (Key_GUID('c9Agt_Sym_Key'), PublicToken)
FROM c9Agent.dbo.MFA_CONFIGURATION;
GO
COMMIT TRAN
CLOSE SYMMETRIC KEY c9Agt_Sym_Key;
GO

OPEN SYMMETRIC KEY c9Agt_Sym_Key
DECRYPTION BY CERTIFICATE c9Agt_Cert;
BEGIN TRAN
UPDATE c9Agent.dbo.MFA_CONFIGURATION
SET PrivateEncryptKey = EncryptByKey (Key_GUID('c9Agt_Sym_Key'), PrivateToken)
FROM c9Agent.dbo.MFA_CONFIGURATION;
GO
COMMIT TRAN
CLOSE SYMMETRIC KEY c9Agt_Sym_Key;
GO

Insert Into dbo.AUTH_USER
Select 
A.ServiceId,
B.UserCode,
LOWER(NEWID()),
NULL,
Concat('https://localhost/azure_ad/auth/',LOWER(A.ServiceCode)),
Concat('192.168.11.',SUBSTRING(CAST(ABS(CHECKSUM(NEWID())) AS nvarchar(max)),1,2)),
GETDATE(),NULL
From dbo.SERVICE A Join
dbo.[USER] B
ON A.ServiceId = B.ServiceId

Insert Into dbo.AUTH_ROLE_DEF (RoleId,RoleDesc,ServiceType,ServiceCode,CreatedOnUtc,UpdatedOnUtc)
Values
('AGT_ADMIN','Agent Administrator','Agent','AGT',GETDATE(),NULL),
('AGT_EXEC','Agent Executor','Agent','AGT',GETDATE(),NULL),
('WFD_ADMIN','WorkFlow Administrator','WorkFlow','WFD',GETDATE(),NULL),
('WFD_EXEC','WorkFlow Executor','WorkFlow','WFD',GETDATE(),NULL),
('SRV_ADMIN','Service Administrator','Service','SRV',GETDATE(),NULL),
('SRV_EXEC','Service Executor','Service','SRV',GETDATE(),NULL),
('API_ADMIN','Api Administrator','Api','API',GETDATE(),NULL),
('API_EXEC','Api Executor','Api','API',GETDATE(),NULL),
('MDW_ADMIN','Middleware Administrator','Middleware','MDW',GETDATE(),NULL),
('MDW_EXEC','Middleware Executor','Middleware','MDW',GETDATE(),NULL);

-- update agent token

OPEN SYMMETRIC KEY c9Agt_Sym_Key
DECRYPTION BY CERTIFICATE c9Agt_Cert;
BEGIN TRAN
UPDATE c9Agent.dbo.AGENT_TOKEN
SET PublicEncryptKey = EncryptByKey (Key_GUID('c9Agt_Sym_Key'), PublicToken)
FROM c9Agent.dbo.AGENT_TOKEN;
GO
COMMIT TRAN
CLOSE SYMMETRIC KEY c9Agt_Sym_Key;
GO

OPEN SYMMETRIC KEY c9Agt_Sym_Key
DECRYPTION BY CERTIFICATE c9Agt_Cert;
BEGIN TRAN
UPDATE c9Agent.dbo.AGENT_TOKEN
SET PrivateEncryptKey = EncryptByKey (Key_GUID('c9Agt_Sym_Key'), PrivateToken)
FROM c9Agent.dbo.AGENT_TOKEN;
GO
COMMIT TRAN
CLOSE SYMMETRIC KEY c9Agt_Sym_Key;
GO

Insert Into dbo.AGENT_BATCH_INSTANCE
Select ServiceId,AgentCode,Concat('B_',ServiceCode,'_SYN_EXEC'),NULL,GETDATE(),NULL From dbo.AGENT
Union All
Select ServiceId,AgentCode,Concat('B_',ServiceCode,'_MOV_HIS_EXEC'),NULL,GETDATE(),NULL From dbo.AGENT
Union All
Select ServiceId,AgentCode,Concat('B_',ServiceCode,'_SND_DTA_EXEC'),NULL,GETDATE(),NULL From dbo.AGENT
Union All
Select ServiceId,AgentCode,Concat('B_',ServiceCode,'_JOB_EXEC'),NULL,GETDATE(),NULL From dbo.AGENT
Order By ServiceId


OPEN SYMMETRIC KEY c9Agt_Sym_Key
DECRYPTION BY CERTIFICATE c9Agt_Cert;
BEGIN TRAN
UPDATE c9Agent.dbo.AUTH_USER
SET AuthEncyptKey = EncryptByKey (Key_GUID('c9Agt_Sym_Key'), AuthKey)
FROM c9Agent.dbo.AUTH_USER;
GO
COMMIT TRAN
CLOSE SYMMETRIC KEY c9Agt_Sym_Key;
GO

Insert Into dbo.AGENT_CONFIGURATION (ConfigCode,ConfigValue,ConfigType,ConfigGroup,ConfigStatus,CreatedOnUtc,UpdatedOnUtc)
Values
('1','Yes','CSTS','AGT','A',GETDATE(),NULL),
('1','Yes','CSTS','AGT','A',GETDATE(),NULL),
('Y','Yes','TSTS','AGT','A',GETDATE(),NULL),
('N','Yes','TSTS','AGT','A',GETDATE(),NULL);

Insert Into dbo.AGENT_CONFIGURATION (ConfigCode,ConfigValue,ConfigType,ConfigGroup,ConfigStatus,CreatedOnUtc,UpdatedOnUtc)
Values
('c9agt','c9Agent Executor','AGTUSR','AGT','A',GETDATE(),NULL);

Insert Into dbo.WORKFLOW
Select Concat('WFD_',ServiceCode,'_INIT'),Concat('https://localhots/c9agent/',LOWER(ServiceCode),'/init'),ServiceId,ServiceCode,GETDATE(),NULL 
From dbo.SERVICE
Union All
Select Concat('WFD_',ServiceCode,'_EXEC'),Concat('https://localhots/c9agent/',LOWER(ServiceCode),'/exec'),ServiceId,ServiceCode,GETDATE(),NULL 
From dbo.SERVICE
Union All
Select Concat('WFD_',ServiceCode,'_AUTH'),Concat('https://localhots/c9agent/',LOWER(ServiceCode),'/auth'),ServiceId,ServiceCode,GETDATE(),NULL 
From dbo.SERVICE
Union All
Select Concat('WFD_',ServiceCode,'_PUT'),Concat('https://localhots/c9agent/',LOWER(ServiceCode),'/put'),ServiceId,ServiceCode,GETDATE(),NULL 
From dbo.SERVICE
Union All
Select Concat('WFD_',ServiceCode,'_GET'),Concat('https://localhots/c9agent/',LOWER(ServiceCode),'/get'),ServiceId,ServiceCode,GETDATE(),NULL 
From dbo.SERVICE
Union All
Select Concat('WFD_',ServiceCode,'_POST'),Concat('https://localhots/c9agent/',LOWER(ServiceCode),'/post'),ServiceId,ServiceCode,GETDATE(),NULL 
From dbo.SERVICE
Union All
Select Concat('WFD_',ServiceCode,'_DELE'),Concat('https://localhots/c9agent/',LOWER(ServiceCode),'/delete'),ServiceId,ServiceCode,GETDATE(),NULL 
From dbo.SERVICE
Union All
Select Concat('WFD_',ServiceCode,'_OPN_API_CON'),Concat('https://localhots/c9agent/',LOWER(ServiceCode),'/opn/api/conn'),ServiceId,ServiceCode,GETDATE(),NULL 
From dbo.SERVICE
Union All
Select Concat('WFD_',ServiceCode,'_CLS_API_CON'),Concat('https://localhots/c9agent/',LOWER(ServiceCode),'/cls/api/conn'),ServiceId,ServiceCode,GETDATE(),NULL 
From dbo.SERVICE
Order By ServiceId

Insert Into dbo.ROLE_PERMISSION
Select RoleId,ServiceCode,'1','1','1','1','1','1','1','1',GETDATE(),NULL From dbo.AUTH_ROLE_DEF

-- TEMPLATE

Insert Into dbo.TEMPLATE
Select Concat('TMP_',ServiceCode,'_EXEC'),'version: "3"

services:
  viz:
    build: .
    volumes:
    - "/var/run/docker.sock:/var/run/docker.sock"
    ports:
    - "8080:8080"',ServiceId,GETDATE(),NULL From dbo.SERVICE

	Insert Into dbo.TEMPLATE
Select Concat('TMP_',ServiceCode,'_DPLY'),'version: 2.1

# Define the jobs we want to run for this project
jobs:
  build:
    docker:
      - image: cimg/base:2023.03
    steps:
      - checkout
      - run: echo "this is the build job"
  test:
    docker:
      - image: cimg/base:2023.03
    steps:
      - checkout
      - run: echo "this is the test job"

# Orchestrate our job run sequence
workflows:
  build_and_test:
    jobs:
      - build
      - test
',ServiceId,GETDATE(),NULL From dbo.SERVICE

Insert Into dbo.TEMPLATE
Select Concat('TMP_',ServiceCode,'_AGENT'),'name: example-basic
# This workflow represents a set of basic End-to-End tests
on:
  push:
    branches:
      - "master"
  pull_request:
  workflow_dispatch:

jobs:

  basic-ubuntu-20:
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Cypress tests
        # normally you would write
        # uses: cypress-io/github-action@v6
        uses: ./
        # the parameters below are only necessary
        # because we are running these examples in a monorepo
        with:
          working-directory: examples/basic
          # just for full picture after installing Cypress
          # print information about detected browsers, etc
          # see https://on.cypress.io/command-line#cypress-info
          build: npx cypress info

  basic-ubuntu-22:
    runs-on: ubuntu-22.04
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Cypress tests
        uses: ./
        with:
          working-directory: examples/basic
          build: npx cypress info

  basic-on-windows:
    runs-on: windows-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Cypress tests
        uses: ./
        with:
          working-directory: examples/basic
          build: npx cypress info

  basic-on-mac:
    runs-on: macos-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Cypress tests
        uses: ./
        with:
          working-directory: examples/basic
          build: npx cypress info
',ServiceId,GETDATE(),NULL From dbo.SERVICE


Insert Into dbo.AGENT_AUDITLOG
Select LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),10,14)),'c9Agent' [Database],'dbo' [Schema],A.name [TableName],B.rows [RowCount],GETDATE(),GETDATE(),NULL From 
sys.sysobjects A Join sys.sysindexes B
On A.id = B.id
And B.indid In (0,1)
And A.xtype = 'U'
Order By B.rows Desc

-- environment variable

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'Organization',Organization,GETDATE(),NULL From dbo.ORGANIZATION

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'UserName',UserCode,GETDATE(),NULL From dbo.[USER]

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'UserCode',UserName,GETDATE(),NULL From dbo.[USER]

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'ServiceCode',ServiceCode,GETDATE(),NULL From dbo.[USER]

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'ServiceName',ServiceName,GETDATE(),NULL From dbo.SERVICE

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'DatabaseLink',DatabaseLink,GETDATE(),NULL From dbo.ENVIRONMENT

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'ServiceLink',ServiceLink,GETDATE(),NULL From dbo.ENVIRONMENT

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'DatabasePort',DatabasePort,GETDATE(),NULL From dbo.ENVIRONMENT

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'ServicePort',ServicePort,GETDATE(),NULL From dbo.ENVIRONMENT

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'ApiLink',ApiLink,GETDATE(),NULL From dbo.ENVIRONMENT

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'ApiPort',ApiPort,GETDATE(),NULL From dbo.ENVIRONMENT

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'ApiBody',ApiBody,GETDATE(),NULL From dbo.API

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'AgentCode',AgentCode,GETDATE(),NULL From dbo.AGENT

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'AgentBatchInstance',BatchInstance,GETDATE(),NULL From dbo.AGENT_BATCH_INSTANCE

Insert Into dbo.ENVIRONMENT_VARIABLE
Select Lower(NEWID()),'TemplateCode',TemplateId,GETDATE(),NULL From dbo.TEMPLATE

-- AGENT_ADMIN

Insert Into dbo.AGENT_ADMIN 
Select 
ServiceId,
ServiceCode,
AgentCode,
AgentName,
Concat(Lower(AgentCode),'-@9agent.sys'),
'01-12346',
Concat('org_url/',ServiceId,'/',Lower(NEWID()),'/',LOWER(NEWID())),
Concat('img/opt/source/',LOWER(NEWID()),'/',Lower(NEWID()),'/',LOWER(NEWID()),'/',LOWER(NEWID()),'/',Lower(NEWID()),'/',LOWER(NEWID())),
GETDATE(),
NULL
From AGENT

-- service variable
With Tbl_statement1 As
(SELECT
	t.name,'CREATE TABLE '  + SCHEMA_NAME(t.schema_id) + '.' + t.name + ' (' +
		STUFF ((
			SELECT ', ' + c2.name + ' ' + type_name(c2.user_type_id) +
				CASE
					WHEN c2.is_nullable = 1 THEN 'NULL'
					ELSE ' NOT NULL'
				END + 
				CASE
					WHEN c2.column_id = 1 AND c2.is_identity = 1 THEN ' IDENTITY (1,1)'
					ELSE ''
				END +
				CASE
					WHEN pk.column_id IS NOT NULL THEN ' PRIMARY KEY'
					ELSE ''
				END
			FROM sys.columns c2
			LEFT JOIN (
				SELECT ic.object_id, ic.column_id, ic.index_column_id
				FROM sys.index_columns ic
				JOIN sys.indexes i ON 
						i.object_id  = ic.object_id
					AND i.index_id = ic.index_id
				WHERE i.is_primary_key = 1
			) pk ON 
					pk.object_id = c2.object_id
				AND pk.column_id = c2.column_id
			WHERE c2.object_id = t.object_id
			ORDER BY c2.column_id
			FOR XML PATH (''), TYPE
			).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + 
		')' DDL_Statement
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'dbo')
Insert Into c9Agent.dbo.SERVICE_VARIABLE
Select 
LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),
'c9jpt',
'jupiter',
TABLE_NAME,
A.DDL_Statement,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
GETDATE(),
NULL
From Tbl_statement1 A Join
INFORMATION_SCHEMA.TABLES B 
On A.name = B.TABLE_NAME

Insert Into c9Agent.dbo.SERVICE_VARIABLE (VarRefNo,DatabaseId,DatabaseName,ConfigBody,DataBody,Ref1,Val1,Rel2,Val2,Ref3,Val3,Ref4,Val4,Ref5,Val5,CreatedOnUtc,UpdatedOnUtc)
Values
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9app','c9app','ApplicationInstance',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9app','c9app','ApplicationAlias',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9app','c9app','ApplicationExtension',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9app','c9app','Application',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9app','c9app','ApplicationConfiguration',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9app','c9app','Workflow',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9app','c9app','WorkflowExec',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9app','c9app','WorkflowExecLog',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL);

Insert Into c9Agent.dbo.SERVICE_VARIABLE (VarRefNo,DatabaseId,DatabaseName,ConfigBody,DataBody,Ref1,Val1,Rel2,Val2,Ref3,Val3,Ref4,Val4,Ref5,Val5,CreatedOnUtc,UpdatedOnUtc)
Values
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ctm','c9customer','CustomerProfile',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ctm','c9customer','CustomerExtension',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ctm','c9customer','Password',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ctm','c9customer','CustomerHistory',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ctm','c9customer','CustomerConfiguration',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ctm','c9customer','Workflow',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ctm','c9customer','WorkflowExec',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ctm','c9customer','WorkflowExecLog',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL);

Insert Into c9Agent.dbo.SERVICE_VARIABLE (VarRefNo,DatabaseId,DatabaseName,ConfigBody,DataBody,Ref1,Val1,Rel2,Val2,Ref3,Val3,Ref4,Val4,Ref5,Val5,CreatedOnUtc,UpdatedOnUtc)
Values
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9rpt','c9report','ReportProfile',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9rpt','c9report','ReportBody',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9rpt','c9report','ReportConfigBody',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9rpt','c9report','ReportDataConnection',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9rpt','c9report','ReportConfiguration',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9rpt','c9report','Workflow',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9rpt','c9report','WorkflowExec',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9rpt','c9report','WorkflowExecLog',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL);

Insert Into c9Agent.dbo.SERVICE_VARIABLE (VarRefNo,DatabaseId,DatabaseName,ConfigBody,DataBody,Ref1,Val1,Rel2,Val2,Ref3,Val3,Ref4,Val4,Ref5,Val5,CreatedOnUtc,UpdatedOnUtc)
Values
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9bth','c9batch','BatchInstance',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9bth','c9batch','BatchInstanceExecute',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9bth','c9batch','BatchThread',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9bth','c9batch','BatchLog',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9bth','c9batch','BatchtConfiguration',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9bth','c9batch','Workflow',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9bth','c9batch','WorkflowExec',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9bth','c9batch','WorkflowExecLog',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL);

Insert Into c9Agent.dbo.SERVICE_VARIABLE (VarRefNo,DatabaseId,DatabaseName,ConfigBody,DataBody,Ref1,Val1,Rel2,Val2,Ref3,Val3,Ref4,Val4,Ref5,Val5,CreatedOnUtc,UpdatedOnUtc)
Values
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9pmt','c9payment','Payment',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9pmt','c9payment','PaymentInstance',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9pmt','c9payment','PaymentExecute',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9pmt','c9payment','PaymentApi',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9pmt','c9payment','PaymentConfiguration',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9pmt','c9payment','Workflow',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9pmt','c9payment','WorkflowExec',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9pmt','c9payment','WorkflowExecLog',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL);

Insert Into c9Agent.dbo.SERVICE_VARIABLE (VarRefNo,DatabaseId,DatabaseName,ConfigBody,DataBody,Ref1,Val1,Rel2,Val2,Ref3,Val3,Ref4,Val4,Ref5,Val5,CreatedOnUtc,UpdatedOnUtc)
Values
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9adm','c9admin','UserProfile',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9adm','c9admin','AdminServiceExecute',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9adm','c9admin','Administrator',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9adm','c9admin','UserPassword',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9adm','c9admin','AdminConfiguration',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9adm','c9admin','Workflow',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9adm','c9admin','WorkflowExec',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9adm','c9admin','WorkflowExecLog',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL);

Insert Into c9Agent.dbo.SERVICE_VARIABLE (VarRefNo,DatabaseId,DatabaseName,ConfigBody,DataBody,Ref1,Val1,Rel2,Val2,Ref3,Val3,Ref4,Val4,Ref5,Val5,CreatedOnUtc,UpdatedOnUtc)
Values
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ath','c9auth','AuthInstance',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ath','c9auth','PublicAccessToken',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ath','c9auth','PrivateAccessToken',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ath','c9auth','AuthExecute',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ath','c9auth','AuthConfiguration',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ath','c9auth','Workflow',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ath','c9auth','WorkflowExec',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL),
(LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),'c9ath','c9auth','WorkflowExecLog',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),NULL);

Use [c9Agent]

;With Tbl_statement As
(SELECT
	t.name,'CREATE TABLE '  + SCHEMA_NAME(t.schema_id) + '.' + t.name + ' (' +
		STUFF ((
			SELECT ', ' + c2.name + ' ' + type_name(c2.user_type_id) +
				CASE
					WHEN c2.is_nullable = 1 THEN 'NULL'
					ELSE ' NOT NULL'
				END + 
				CASE
					WHEN c2.column_id = 1 AND c2.is_identity = 1 THEN ' IDENTITY (1,1)'
					ELSE ''
				END +
				CASE
					WHEN pk.column_id IS NOT NULL THEN ' PRIMARY KEY'
					ELSE ''
				END
			FROM sys.columns c2
			LEFT JOIN (
				SELECT ic.object_id, ic.column_id, ic.index_column_id
				FROM sys.index_columns ic
				JOIN sys.indexes i ON 
						i.object_id  = ic.object_id
					AND i.index_id = ic.index_id
				WHERE i.is_primary_key = 1
			) pk ON 
					pk.object_id = c2.object_id
				AND pk.column_id = c2.column_id
			WHERE c2.object_id = t.object_id
			ORDER BY c2.column_id
			FOR XML PATH (''), TYPE
			).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + 
		')' DDL_Statement
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'dbo')
Insert Into c9Agent.dbo.SERVICE_VARIABLE
Select 
LOWER(SUBSTRING(CAST(NEWID() AS NVARCHAR(MAX)),1,8)),
'c9agt',
TABLE_CATALOG,
TABLE_NAME,
A.DDL_Statement,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
GETDATE(),
NULL
From Tbl_statement A Join
INFORMATION_SCHEMA.TABLES B 
On A.name = B.TABLE_NAME








