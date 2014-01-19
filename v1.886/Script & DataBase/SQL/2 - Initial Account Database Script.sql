SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ACCOUNT_LOGIN') AND type in (N'P', N'PC'))
    DROP PROCEDURE ACCOUNT_LOGIN;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ACCOUNT_PREMIUM') AND type in (N'P', N'PC'))
    DROP PROCEDURE ACCOUNT_PREMIUM;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ACCOUNT_LOGOUT') AND type in (N'P', N'PC'))
    DROP PROCEDURE ACCOUNT_LOGOUT;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CLEAR_REMAIN_USERS') AND type in (N'P', N'PC'))
    DROP PROCEDURE CLEAR_REMAIN_USERS;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SET_LOGIN_INFO') AND type in (N'P', N'PC'))
    DROP PROCEDURE SET_LOGIN_INFO;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'LOAD_PREMIUM_SERVICE_USER') AND type in (N'P', N'PC'))
    DROP PROCEDURE LOAD_PREMIUM_SERVICE_USER;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SAVE_PREMIUM_SERVICE_USER') AND type in (N'P', N'PC'))
    DROP PROCEDURE SAVE_PREMIUM_SERVICE_USER;
GO

CREATE PROCEDURE ACCOUNT_LOGIN
@strAccountID varchar(21),
@strPasswd varchar(28)
AS

DECLARE @strHashPassword varchar(28)

SELECT @strHashPassword = strPasswd FROM TB_USER WHERE strAccountID = @strAccountID

IF (@@ROWCOUNT = 0)
BEGIN
	INSERT INTO TB_USER (strAccountID, strPasswd) VALUES (@strAccountID, @strPasswd)
	RETURN 1
END
ELSE IF (@strHashPassword != @strPasswd)
	RETURN 3
ELSE
BEGIN
	DELETE FROM CURRENTUSER WHERE strAccountID = @strAccountID
	RETURN 1
END
GO

CREATE PROCEDURE ACCOUNT_PREMIUM
@strAccountID char(20)
AS
DECLARE @sHours smallint
DECLARE @dtPremiumTime datetime

-- Get the current premium expire time and current premium type.
SELECT @dtPremiumTime = dtPremiumTime FROM TB_USER WHERE strAccountID = @strAccountID

-- How many time differ between now and the last premium expire date.
SET @sHours = DATEDIFF(HH, GETDATE(), @dtPremiumTime)

-- Check if the last premium expire date is null/empty or
-- the hours between now and the last premium expire date is below or equal to 0
IF (@sHours <= 0 OR @sHours IS NULL OR @@ERROR <> 0 )
	RETURN -1

RETURN @sHours
GO

CREATE PROCEDURE ACCOUNT_LOGOUT
@strAccountID varchar(21)
AS

DELETE FROM CURRENTUSER WHERE strAccountID = @strAccountID
GO

CREATE PROCEDURE CLEAR_REMAIN_USERS
@strServerIP varchar(50)
AS

DELETE FROM CURRENTUSER WHERE strServerIP = @strServerIP
GO

CREATE PROCEDURE SET_LOGIN_INFO
@strAccountID varchar(20),
@strCharID varchar(20),
@nServerno smallint,
@strServerIP varchar(50),
@strClientIP varchar(50),
@bInit tinyint
AS

IF (@bInit = 1)
	INSERT INTO CURRENTUSER (strAccountID, strCharID, nServerNo, strServerIP, strClientIP) VALUES (@strAccountID, @strCharID, @nServerno, @strServerIP, @strClientIP)
ELSE
	UPDATE CURRENTUSER SET nServerNo = @nServerno, strServerIP = @strServerIP WHERE strAccountID = @strAccountID

UPDATE TB_USER SET strClientIP = @strClientIP WHERE strAccountID = @strAccountID

RETURN 1
GO

CREATE PROCEDURE LOAD_PREMIUM_SERVICE_USER
@strAccountID char(20),
@bType tinyint OUTPUT,
@sTime smallint OUTPUT
AS
DECLARE @bPremiumType tinyint
DECLARE @dtPremiumTime datetime

-- Get the current premium expire time and current premium type.
SELECT @bPremiumType = bPremiumType, @dtPremiumTime = dtPremiumTime FROM TB_USER WHERE strAccountID = @strAccountID

-- How many time differ between now and the last premium expire date.
SET @sTime = DATEDIFF(HH, GETDATE(), @dtPremiumTime)
SET @bType = @bPremiumType

-- Check if the last premium expire date is null/empty or
-- the hours between now and the last premium expire date is below or equal to 0
IF (@sTime <= 0 OR @sTime IS NULL OR @@ERROR <> 0 )
BEGIN
	SET @bType = 0
	SET @sTime = 0
END
GO

CREATE PROCEDURE SAVE_PREMIUM_SERVICE_USER
@strAccountID char(20),
@strCharID char(20),
@bType tinyint,
@sTime smallint
AS
DECLARE @dtExpiry datetime

SET @dtExpiry = DATEADD(HH, @sTime, GETDATE())

UPDATE TB_USER SET bPremiumType = @bType, dtPremiumTime = @dtExpiry, sHours = @sTime WHERE strAccountID = @strAccountID
GO