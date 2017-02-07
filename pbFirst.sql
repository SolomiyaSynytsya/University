/*--CREATE MASTER KEY;

CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
    IDENTITY = 'solomiya',
    SECRET = 'I+N7vdeQ6SpLSdAH2y3aUVCW+i3TTlSTsc6nG+RM2lldrn26ctdHyjWSQUHhhDzVnQT8ORn10JCXMT/EM5s1nQ=='
;
CREATE EXTERNAL DATA SOURCE AzureStorage
WITH (
    TYPE = HADOOP,
    LOCATION = 'wasbs://first@ssvstorage.blob.core.windows.net',
    CREDENTIAL = AzureStorageCredential
);
CREATE EXTERNAL FILE FORMAT TextFile
WITH (
    FORMAT_TYPE = DelimitedText,
    FORMAT_OPTIONS (FIELD_TERMINATOR = ',')
);
CREATE EXTERNAL TABLE dbo.Numbers (
    DateId INT NOT NULL,
    CalendarQuarter TINYINT NOT NULL,
    FiscalQuarter TINYINT NOT NULL
)
WITH (
    LOCATION='/numbers.txt',
    DATA_SOURCE=AzureStorage,
    FILE_FORMAT=TextFile
);
drop external table dbo.Numbers
SELECT * FROM dbo.Numbers;

CREATE TABLE dbo.TestData
WITH
(   
    CLUSTERED COLUMNSTORE INDEX,
    DISTRIBUTION = ROUND_ROBIN
)
AS
SELECT * FROM [dbo].[Numbers];

CREATE STATISTICS [DateId] on [TestData] ([DateId]);
CREATE STATISTICS [CalendarQuarter] on [TestData] ([CalendarQuarter]);
CREATE STATISTICS [FiscalQuarter] on [TestData] ([FiscalQuarter]);
*/

CREATE DATABASE SCOPED CREDENTIAL AzureCredentials
WITH
    IDENTITY = 'solomiya',
    SECRET = '5oKbmhR8t9cQVk5oSgele8L9yR8fhzpqevM7eAboBTM4yO0J+75F4VEOv9UkhK8KQdhq0alVRylnWR7/i1fDRw=='
;

CREATE EXTERNAL DATA SOURCE SSVAzureStorage
WITH (
    TYPE = HADOOP,
    LOCATION = 'wasbs://ssv@ssvstor.blob.core.windows.net',
    CREDENTIAL = AzureCredentials
);

CREATE EXTERNAL FILE FORMAT SimpleTextFile
WITH (
    FORMAT_TYPE = DelimitedText,
    FORMAT_OPTIONS (FIELD_TERMINATOR = ',')
);

CREATE EXTERNAL TABLE dbo.NewNumbers (
    DateId INT NOT NULL,
    CalendarQuarter TINYINT NOT NULL,
    FiscalQuarter TINYINT NOT NULL
)
WITH (
    LOCATION='/numbers.txt',
    DATA_SOURCE=SSVAzureStorage,
    FILE_FORMAT=SimpleTextFile
);

select * from NewNumbers

CREATE TABLE dbo.NewNums
WITH
(   
    CLUSTERED COLUMNSTORE INDEX,
    DISTRIBUTION = ROUND_ROBIN
)
AS
SELECT * FROM NewNumbers;

select * from NewNums