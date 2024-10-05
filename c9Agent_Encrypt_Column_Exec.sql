Use [c9Agent]
Go

-- create master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'c9Agt@123';

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

-- create certificate
CREATE CERTIFICATE c9Agt_Cert WITH SUBJECT = 'Protect c9Agent';

SELECT name CertName, 
    certificate_id CertID, 
    pvt_key_encryption_type_desc EncryptType, 
    issuer_name Issuer
FROM sys.certificates;

-- symmetric key
CREATE SYMMETRIC KEY c9Agt_Sym_Key WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE c9Agt_Cert;

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;