SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'GAME_LOGIN') AND type in (N'P', N'PC'))
    DROP PROCEDURE GAME_LOGIN;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'NATION_SELECT') AND type in (N'P', N'PC'))
    DROP PROCEDURE NATION_SELECT;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CREATE_NEW_CHAR') AND type in (N'P', N'PC'))
    DROP PROCEDURE CREATE_NEW_CHAR;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CHANGE_HAIR') AND type in (N'P', N'PC'))
    DROP PROCEDURE CHANGE_HAIR;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'LOAD_USER_DATA') AND type in (N'P', N'PC'))
    DROP PROCEDURE LOAD_USER_DATA;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'USER_ITEM_SEAL') AND type in (N'P', N'PC'))
    DROP PROCEDURE USER_ITEM_SEAL;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'INSERT_FRIEND_LIST') AND type in (N'P', N'PC'))
    DROP PROCEDURE INSERT_FRIEND_LIST;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DELETE_FRIEND_LIST') AND type in (N'P', N'PC'))
    DROP PROCEDURE DELETE_FRIEND_LIST;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'UPDATE_USER_DATA') AND type in (N'P', N'PC'))
    DROP PROCEDURE UPDATE_USER_DATA;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CREATE_KNIGHTS') AND type in (N'P', N'PC'))
    DROP PROCEDURE CREATE_KNIGHTS;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'UPDATE_KNIGHTS') AND type in (N'P', N'PC'))
    DROP PROCEDURE UPDATE_KNIGHTS;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DELETE_KNIGHTS') AND type in (N'P', N'PC'))
    DROP PROCEDURE DELETE_KNIGHTS;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DONATE_CLAN_POINTS') AND type in (N'P', N'PC'))
    DROP PROCEDURE DONATE_CLAN_POINTS;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MAIL_BOX_CHECK_COUNT') AND type in (N'P', N'PC'))
    DROP PROCEDURE MAIL_BOX_CHECK_COUNT;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MAIL_BOX_REQUEST_LIST') AND type in (N'P', N'PC'))
    DROP PROCEDURE MAIL_BOX_REQUEST_LIST;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MAIL_BOX_SEND') AND type in (N'P', N'PC'))
    DROP PROCEDURE MAIL_BOX_SEND;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MAIL_BOX_READ') AND type in (N'P', N'PC'))
    DROP PROCEDURE MAIL_BOX_READ;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MAIL_BOX_GET_ITEM') AND type in (N'P', N'PC'))
    DROP PROCEDURE MAIL_BOX_GET_ITEM;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'INSERT_USER_DAILY_OP') AND type in (N'P', N'PC'))
    DROP PROCEDURE INSERT_USER_DAILY_OP;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'UPDATE_USER_DAILY_OP') AND type in (N'P', N'PC'))
    DROP PROCEDURE UPDATE_USER_DAILY_OP;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'UPDATE_USER_KNIGHTS_RANK') AND type in (N'P', N'PC'))
    DROP PROCEDURE UPDATE_USER_KNIGHTS_RANK;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'UPDATE_USER_PERSONAL_RANK') AND type in (N'P', N'PC'))
    DROP PROCEDURE UPDATE_USER_PERSONAL_RANK;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'UPDATE_KNIGHTS_RATING') AND type in (N'P', N'PC'))
    DROP PROCEDURE UPDATE_KNIGHTS_RATING;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'RESET_LOYALTY_MONTHLY') AND type in (N'P', N'PC'))
    DROP PROCEDURE RESET_LOYALTY_MONTHLY;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'UPDATE_RANKS') AND type in (N'P', N'PC'))
    DROP PROCEDURE UPDATE_RANKS;
GO

CREATE PROCEDURE GAME_LOGIN
@strAccountID varchar(21),
@strPasswd varchar(28)
AS

DECLARE @bNation tinyint
DECLARE @strHashPassword varchar(28)

SELECT @strHashPassword = strPasswd FROM TB_USER WHERE strAccountID = @strAccountID

IF (@@ROWCOUNT = 0)
	RETURN -1
ELSE IF (@strHashPassword <> @strPasswd)
	RETURN -1

SELECT @bNation = bNation FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID

IF (@@ROWCOUNT = 0)
	RETURN 0

RETURN @bNation
GO

CREATE PROCEDURE NATION_SELECT
@strAccountID varchar(21),
@bNation tinyint
AS

DECLARE @bCount tinyint

BEGIN TRAN
	SELECT @bCount = COUNT(strAccountID) FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID

	IF (@bCount = 0)
		INSERT INTO ACCOUNT_CHAR (strAccountID, bNation) VALUES (@strAccountID, @bNation)

	SELECT @bCount = COUNT(strAccountID) FROM WAREHOUSE WHERE strAccountID = @strAccountID

	IF (@bCount = 0)
		INSERT INTO WAREHOUSE (strAccountID, nMoney, dwTime, WarehouseData, strSerial) VALUES (@strAccountID, 0, 0, 0x00, 0x00)

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 0
	END
COMMIT TRAN

RETURN @bNation
GO

CREATE PROCEDURE CREATE_NEW_CHAR
@strAccountID varchar(21),
@index tinyint,
@strCharID varchar(21),
@bRace tinyint,
@sClass smallint,
@nHair int,
@bFace tinyint,
@bStr tinyint,
@bSta tinyint,
@bDex tinyint,
@bIntel tinyint,
@bCha tinyint
AS

DECLARE @bNation tinyint
DECLARE @bCharCount tinyint
DECLARE @bCount tinyint

SELECT @bNation = bNation, @bCharCount = bCharNum FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID

IF (@bNation = 1 AND @bRace > 10)
	RETURN 2
ELSE IF (@bNation = 2 AND @bRace < 10)
	RETURN 2
ELSE IF (@bNation <> 1 AND @bNation <> 2)
	RETURN 2

SELECT @bCount = COUNT(strUserID) FROM USERDATA WHERE strUserID = @strCharID

IF (@bCount > 0)
	RETURN 3

BEGIN TRAN
	IF (@index = 0)
		UPDATE ACCOUNT_CHAR SET strCharID1 = @strCharID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@index = 1)
		UPDATE ACCOUNT_CHAR SET strCharID2 = @strCharID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@index = 2)
		UPDATE ACCOUNT_CHAR SET strCharID3 = @strCharID, bCharNum += 1 WHERE strAccountID = @strAccountID

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 4
	END

	INSERT INTO USERDATA (strUserID, Nation, Race, Class, HairRGB, Face, Strong, Sta, Dex, Intel, Cha) 
	VALUES (@strCharID, @bNation, @bRace, @sClass, @nHair, @bFace, @bStr, @bSta, @bDex, @bIntel, @bCha)

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 4
	END
COMMIT TRAN

RETURN 0
GO

CREATE PROCEDURE CHANGE_HAIR
@strAccountID varchar(21),
@strCharID varchar(21),
@bType tinyint,
@bFace tinyint,
@nHair int
AS

IF (NOT EXISTS(SELECT strAccountID FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID AND @strCharID IN(strCharID1, strCharID2, strCharID3)))
	RETURN 1

UPDATE USERDATA SET HairRGB = @nHair, Face = @bFace WHERE strUserID = @strCharID 

RETURN 0
GO

CREATE PROCEDURE LOAD_USER_DATA
@strAccountID varchar(21),
@strCharID varchar(21)
AS

DECLARE @strCharID1 varchar(21), @strCharID2 varchar(21), @strCharID3 varchar(21)

SELECT	@strCharID1 = ISNULL(strCharID1, ''), 
		@strCharID2 = ISNULL(strCharID2, ''), 
		@strCharID3 = ISNULL(strCharID3, '') 
FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID

IF (@strCharID NOT IN(@strCharID1, @strCharID2, @strCharID3))
	RETURN

SELECT Nation, Race, Class, HairRGB, [Rank], Title, [Level], [Exp], Loyalty, Face, City, Knights, Fame, Hp, Mp, Sp, Strong, Sta, Dex, Intel, Cha, Authority, Points, Gold, Zone, Bind, PX, PZ, PY, dwTime, strSkill, strItem,strSerial, sQuestCount, strQuest, MannerPoint, LoyaltyMonthly FROM USERDATA WHERE strUserID = @strCharID
GO

CREATE PROCEDURE USER_ITEM_SEAL
@strAccountID char(21),
@strCharID char(21),
@strPasswd char(8),
@nItemSerial bigint,
@nItemID int,
@bSealType tinyint
AS

DECLARE @strSealPasswd char(8)

SELECT @strSealPasswd = strSealPasswd FROM TB_USER WHERE strAccountID = @strAccountID

IF (@bSealType < 3 AND @strSealPasswd <> @strPasswd)
BEGIN
	RETURN 4
END
ELSE
BEGIN
	IF (@bSealType = 1 OR @bSealType = 3)
		INSERT INTO SEALED_ITEMS (strAccountID, strUserID, nItemSerial, nItemID, bSealType) VALUES (@strAccountID, @strCharID, @nItemSerial, @nItemID, @bSealType)
	ELSE IF (@bSealType = 2)
		DELETE FROM SEALED_ITEMS WHERE strAccountID = @strAccountID AND strUserID = @strCharID AND nItemSerial = @nItemSerial AND nItemID = @nItemID

	RETURN 1
END

RETURN 2
GO

CREATE PROCEDURE INSERT_FRIEND_LIST
@strUserID char(21),
@strFriend char(21)
AS

DECLARE @strFriend1 char(21), @strFriend2 char(21), @strFriend3 char(21), @strFriend4 char(21), @strFriend5 char(21), @strFriend6 char(21)
DECLARE @strFriend7 char(21), @strFriend8 char(21), @strFriend9 char(21), @strFriend10 char(21), @strFriend11 char(21), @strFriend12 char(21)
DECLARE @strFriend13 char(21), @strFriend14 char(21), @strFriend15 char(21), @strFriend16 char(21), @strFriend17 char(21), @strFriend18 char(21)
DECLARE @strFriend19 char(21), @strFriend20 char(21), @strFriend21 char(21), @strFriend22 char(21), @strFriend23 char(21), @strFriend24 char(21) 

SELECT	@strFriend1 = strFriend1, @strFriend2 = strFriend2,@strFriend3 = strFriend3,@strFriend4 = strFriend4,
		@strFriend5 = strFriend5, @strFriend6 = strFriend6,@strFriend7 = strFriend7,@strFriend8 = strFriend8,
		@strFriend9 = strFriend9, @strFriend10 = strFriend10,@strFriend11 = strFriend11,@strFriend12 = strFriend12,
		@strFriend13 = strFriend13, @strFriend14 = strFriend14,@strFriend15 = strFriend15,@strFriend16 = strFriend16,
		@strFriend17 = strFriend17, @strFriend18 = strFriend18,@strFriend19 = strFriend19,@strFriend20 = strFriend20,
		@strFriend21 = strFriend21, @strFriend22 = strFriend22,@strFriend23 = strFriend23,@strFriend24 = strFriend24 
		FROM FRIEND_LIST WHERE strUserID = @strUserID

IF (@@ROWCOUNT = 0)
BEGIN
	INSERT INTO FRIEND_LIST (strUserID, strFriend1) VALUES (@strUserID, @strFriend)
	IF (@@ERROR <> 0)
		RETURN 1

	RETURN 0
END

IF (@strFriend1 IS NULL)
	UPDATE FRIEND_LIST SET strFriend1 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend2 IS NULL)
	UPDATE FRIEND_LIST SET strFriend2 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend3 IS NULL)
	UPDATE FRIEND_LIST SET strFriend3 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend4 IS NULL)
	UPDATE FRIEND_LIST SET strFriend4 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend5 IS NULL)
	UPDATE FRIEND_LIST SET strFriend5 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend6 IS NULL)
	UPDATE FRIEND_LIST SET strFriend6 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend7 IS NULL)
	UPDATE FRIEND_LIST SET strFriend7 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend8 IS NULL)
	UPDATE FRIEND_LIST SET strFriend8 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend9 IS NULL)
	UPDATE FRIEND_LIST SET strFriend9 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend10 IS NULL)
	UPDATE FRIEND_LIST SET strFriend10 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend11 IS NULL)
	UPDATE FRIEND_LIST SET strFriend11 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend12 IS NULL)
	UPDATE FRIEND_LIST SET strFriend12 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend13 IS NULL)
	UPDATE FRIEND_LIST SET strFriend13 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend14 IS NULL)
	UPDATE FRIEND_LIST SET strFriend14 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend15 IS NULL)
	UPDATE FRIEND_LIST SET strFriend15 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend16 IS NULL)
	UPDATE FRIEND_LIST SET strFriend16 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend17 IS NULL)
	UPDATE FRIEND_LIST SET strFriend17 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend18 IS NULL)
	UPDATE FRIEND_LIST SET strFriend18 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend19 IS NULL)
	UPDATE FRIEND_LIST SET strFriend19 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend20 IS NULL)
	UPDATE FRIEND_LIST SET strFriend20 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend21 IS NULL)
	UPDATE FRIEND_LIST SET strFriend21 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend22 IS NULL)
	UPDATE FRIEND_LIST SET strFriend22 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend23 IS NULL)
	UPDATE FRIEND_LIST SET strFriend23 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend24 IS NULL)
	UPDATE FRIEND_LIST SET strFriend24 = @strFriend WHERE strUserID = @strUserID
ELSE
	RETURN 2

IF (@@ERROR <> 0)
	RETURN 1

RETURN 0
GO

CREATE PROCEDURE DELETE_FRIEND_LIST
@strUserID char(21),
@strFriend char(21)
AS

DECLARE @strFriend1 char(21), @strFriend2 char(21), @strFriend3 char(21), @strFriend4 char(21), @strFriend5 char(21), @strFriend6 char(21)
DECLARE @strFriend7 char(21), @strFriend8 char(21), @strFriend9 char(21), @strFriend10 char(21), @strFriend11 char(21), @strFriend12 char(21)
DECLARE @strFriend13 char(21), @strFriend14 char(21), @strFriend15 char(21), @strFriend16 char(21), @strFriend17 char(21), @strFriend18 char(21)
DECLARE @strFriend19 char(21), @strFriend20 char(21), @strFriend21 char(21), @strFriend22 char(21), @strFriend23 char(21), @strFriend24 char(21) 

SELECT	@strFriend1 = strFriend1, @strFriend2 = strFriend2,@strFriend3 = strFriend3,@strFriend4 = strFriend4,
		@strFriend5 = strFriend5, @strFriend6 = strFriend6,@strFriend7 = strFriend7,@strFriend8 = strFriend8,
		@strFriend9 = strFriend9, @strFriend10 = strFriend10,@strFriend11 = strFriend11,@strFriend12 = strFriend12,
		@strFriend13 = strFriend13, @strFriend14 = strFriend14,@strFriend15 = strFriend15,@strFriend16 = strFriend16,
		@strFriend17 = strFriend17, @strFriend18 = strFriend18,@strFriend19 = strFriend19,@strFriend20 = strFriend20,
		@strFriend21 = strFriend21, @strFriend22 = strFriend22,@strFriend23 = strFriend23,@strFriend24 = strFriend24 
		FROM FRIEND_LIST WHERE strUserID = @strUserID

IF (@@ROWCOUNT = 0)
	RETURN 1

IF (@strFriend1 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend1 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend2 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend2 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend3 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend3 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend4 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend4 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend5 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend5 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend6 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend6 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend7 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend7 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend8 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend8 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend9 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend9 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend10 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend10 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend11 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend11 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend12 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend12 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend13 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend13 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend14 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend14 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend15 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend15 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend16 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend16 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend17 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend17 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend18 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend18 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend19 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend19 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend20 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend20 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend21 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend21 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend22 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend22 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend23 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend23 = NULL WHERE strUserID = @strUserID
ELSE IF (@strFriend24 = @strFriend)
	UPDATE FRIEND_LIST SET strFriend24 = NULL WHERE strUserID = @strUserID
ELSE
	RETURN 2

IF (@@ERROR <> 0)
	RETURN 1

RETURN 0
GO

CREATE PROCEDURE UPDATE_USER_DATA
@strCharID char(21),
@bNation tinyint,
@bRace tinyint,
@sClass smallint,
@nHair int,
@bRank tinyint,
@bTitle tinyint,
@bLevel tinyint,
@iExp bigint,
@nLoyalty int,
@bFace tinyint,
@bCity tinyint,
@sClanID smallint,
@bFame tinyint,
@sHp smallint,
@sMp smallint,
@sSp smallint,
@bStr tinyint,
@bSta tinyint,
@bDex tinyint,
@bIntel tinyint,
@bCha tinyint,
@bAuthority tinyint,
@sPoints smallint,		
@nCoins int,
@bZone tinyint,
@sBind smallint,
@iPosX int,
@iPosZ int,
@iPosY int,
@dwTime int,
@sQuestCount smallint,
@strSkill varchar(10),
@strItem binary(584),
@strSerial binary(584),
@strQuest binary(600),
@nMannerPoint int,
@nLoyaltyMonthly int
AS

UPDATE USERDATA 
SET Nation			= @bNation, 
	Race			= @bRace, 
	Class			= @sClass, 
	HairRGB			= @nHair, 
	[Rank]			= @bRank, 
	Title			= @bTitle, 
	[Level]			= @bLevel, 
	[Exp]			= @iExp, 
	Loyalty			= @nLoyalty, 
	Face			= @bFace, 
	City			= @bCity, 
	Knights			= @sClanID, 
	Fame			= @bFame, 
	Hp				= @sHp, 
	Mp				= @sMp, 
	Sp				= @sSp, 
	Strong			= @bStr, 
	Sta				= @bSta, 
	Dex				= @bDex, 
	Intel			= @bIntel, 
	Cha				= @bCha, 
	Authority		= @bAuthority, 
	Points			= @sPoints, 
	Gold			= @nCoins, 
	[Zone]			= @bZone, 
	Bind			= @sBind, 
	PX				= @iPosX, 
	PZ				= @iPosZ, 
	PY				= @iPosY, 
	dwTime			= @dwTime, 
	strSkill		= @strSkill, 
	strItem			= @strItem, 
	strSerial		= @strSerial, 
	sQuestCount		= @sQuestCount, 
	strQuest		= @strQuest, 
	MannerPoint		= @nMannerPoint, 
	LoyaltyMonthly	= @nLoyaltyMonthly, 
	dtUpdateTime	= GETDATE() 
WHERE strUserID		= @strCharID
GO

CREATE PROCEDURE CREATE_KNIGHTS
@sClanID smallint,
@bNation tinyint,
@bFlag tinyint,
@strKnightsName char(21),
@strChief char(21)
AS

DECLARE @bCount tinyint

SELECT @bCount = COUNT(*) FROM KNIGHTS WHERE IDNum = @sClanID OR IDName = @strKnightsName

IF (@bCount > 0)
	RETURN 3

BEGIN TRAN
	INSERT INTO KNIGHTS (IDNum, Nation, Flag, IDName, Chief) VALUES (@sClanID, @bNation, @bFlag, @strKnightsName, @strChief)
	INSERT INTO KNIGHTS_USER (sIDNum, strUserID) VALUES (@sClanID, @strChief)

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 6
	END
COMMIT TRAN

RETURN 0
GO

CREATE PROCEDURE UPDATE_KNIGHTS
@bType tinyint,
@strCharID char(21),
@sClanID smallint,
@bDomination tinyint
AS

DECLARE @bCount tinyint
DECLARE @bMembers tinyint
DECLARE @bUserMembers tinyint
DECLARE @sKnights smallint
DECLARE @strViceChief1 char(21)
DECLARE @strViceChief2 char(21)
DECLARE @strViceChief3 char(21)

SELECT @bCount = COUNT(*) FROM KNIGHTS WHERE IDNum = @sClanID
IF (@bCount = 0)
	RETURN 7

SELECT @bMembers = Members, @strViceChief1 = ViceChief_1, @strViceChief2 = ViceChief_2, @strViceChief3 = ViceChief_3 FROM KNIGHTS WHERE IDNum = @sClanID
IF (@bType = 18)
BEGIN
	SELECT @bUserMembers = COUNT(*) FROM USERDATA WHERE Knights = @sClanID
	
	IF (@bMembers >= 36 OR @bUserMembers >= 36)
		RETURN 8
END
ELSE IF (@bMembers > 36)
	RETURN 8

SELECT @bCount = COUNT(*) FROM USERDATA WHERE strUserID = @strCharID
IF (@bCount = 0)
	RETURN 2

BEGIN TRAN
	IF (@bType = 18)
	BEGIN
		UPDATE KNIGHTS SET Members += 1 WHERE IDNum = @sClanID
		INSERT INTO KNIGHTS_USER (sIDNum, strUserID) VALUES (@sClanID, @strCharID)
		UPDATE USERDATA SET Knights = @sClanID WHERE strUserID = @strCharID
	END
	ELSE IF (@bType IN(19, 20, 23))
	BEGIN
		IF (@bMembers <= 1)
			UPDATE KNIGHTS SET Members = 1 WHERE IDNum = @sClanID
		ELSE
			UPDATE KNIGHTS SET Members -= 1 WHERE IDNum = @sClanID

		DELETE FROM KNIGHTS_USER WHERE strUserID = @strCharID
		
		IF (@strViceChief1 = @strCharID)
			UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @sClanID	
		IF (@strViceChief2 = @strCharID)
			UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @sClanID	
		IF (@strViceChief3 = @strCharID)
			UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @sClanID	
	END
	ELSE IF (@bType = 25)
	BEGIN
		UPDATE KNIGHTS SET Chief = @strCharID WHERE IDNum = @sClanID
		
		IF (@strViceChief1 = @strCharID)
			UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @sClanID
		IF (@strViceChief2 = @strCharID)
			UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @sClanID
		IF (@strViceChief3 = @strCharID)
			UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @sClanID
	END
	ELSE IF (@bType = 26)
	BEGIN
		IF (@strViceChief1 IS NOT NULL AND @strViceChief2 IS NOT NULL AND @strViceChief3 IS NOT NULL)
		BEGIN
			COMMIT TRAN
			RETURN 8
		END
		IF (@strViceChief1 IS NULL)
			UPDATE KNIGHTS SET ViceChief_1 = @strCharID WHERE IDNum = @sClanID
		ELSE IF (@strViceChief2 IS NULL)
			UPDATE KNIGHTS SET ViceChief_2 = @strCharID WHERE IDNum = @sClanID
		ELSE IF (@strViceChief3 IS NULL)
			UPDATE KNIGHTS SET ViceChief_3 = @strCharID WHERE IDNum = @sClanID
	END
	ELSE IF (@bType = 27)
		UPDATE KNIGHTS SET ViceChief_2 = @strCharID WHERE IDNum = @sClanID
	ELSE IF (@bType = 76)
		UPDATE KNIGHTS SET ClanPointMethod = @bDomination WHERE IDNum = @sClanID
	ELSE IF (@bType = 95)
	BEGIN
		UPDATE KNIGHTS SET Chief = @strCharID WHERE IDNum = @sClanID
		
		IF (@strViceChief1 = @strCharID)
			UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @sClanID
		IF (@strViceChief2 = @strCharID)
			UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @sClanID
		IF (@strViceChief3 = @strCharID)
			UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @sClanID
	END

	IF (@@ERROR <> 0)
	BEGIN	 
		ROLLBACK TRAN
		RETURN 2
	END

	IF (@bType = 20)
	BEGIN
		UPDATE USERDATA SET Knights = -1, Fame = 0 WHERE strUserID = @strCharID
		DELETE FROM KNIGHTS_USER WHERE strUserID = @strCharID
	END
COMMIT TRAN

RETURN 0
GO

CREATE PROCEDURE DELETE_KNIGHTS
@sClanID smallint
AS

DECLARE @bCount tinyint

SELECT @bCount = COUNT(*) FROM KNIGHTS WHERE IDNum = @sClanID

IF (@bCount = 0)
	RETURN 7

BEGIN TRAN
	DELETE FROM KNIGHTS WHERE IDNum = @sClanID
	DELETE FROM KNIGHTS_USER WHERE sIDNum = @sClanID

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 7
	END

	UPDATE USERDATA SET Knights = 0, Fame = 0 WHERE Knights = @sClanID
COMMIT TRAN

RETURN 0
GO

CREATE PROCEDURE DONATE_CLAN_POINTS
@strUserID char(21),
@sClanID smallint,
@nNationalPoints int
AS

BEGIN TRAN
	UPDATE KNIGHTS SET ClanPointFund += @nNationalPoints WHERE IDNum = @sClanID
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		GOTO ERROR

	UPDATE KNIGHTS_USER SET nDonatedNP += @nNationalPoints WHERE strUserID = @strUserID AND sIDNum = @sClanID
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		GOTO ERROR
COMMIT TRAN
RETURN

ERROR: ROLLBACK TRAN
GO

CREATE PROCEDURE MAIL_BOX_CHECK_COUNT
@strRecipientID char(21)
AS

DECLARE @bCount tinyint

SELECT TOP 12 @bCount = COUNT(*) FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND bStatus = 1 AND bDeleted = 0

RETURN @bCount
GO

CREATE PROCEDURE MAIL_BOX_REQUEST_LIST
@strRecipientID char(21),
@bNewLettersOnly tinyint
AS

DECLARE @expiresInDays int = 7

IF (@bNewLettersOnly = 1)
	SELECT TOP 12 nLetterID, bStatus, bType, strSubject, strSenderID, bType, nItemID, sCount, nCoins, YEAR(dtSendDate) * 10000 + MONTH(dtSendDate) * 100 + DAY(dtSendDate), DATEDIFF(DD, GETDATE(), dtSendDate + @expiresInDays) FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND bStatus = 1 AND bDeleted = 0
ELSE
	SELECT TOP 20 nLetterID, bStatus, bType, strSubject, strSenderID, bType, nItemID, sCount, nCoins, YEAR(dtReadDate) * 10000 + MONTH(dtReadDate) * 100 + DAY(dtReadDate), DATEDIFF(DD, dtReadDate, GETDATE()) FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND bStatus = 2 AND bDeleted = 0

RETURN @@ROWCOUNT
GO

CREATE PROCEDURE MAIL_BOX_SEND
@strSenderID char(21),
@strRecipientID char(21),
@strSubject char(31),
@strMessage char(128),
@bType tinyint,
@nItemID int,
@sCount smallint,
@sDurability smallint,
@nSerialNum bigint
AS

IF (NOT EXISTS(SELECT strUserID FROM USERDATA WHERE strUserID = @strRecipientID))
	RETURN -1

INSERT INTO MAIL_BOX (strSenderID, strRecipientID, strSubject, strMessage, bType, nItemID, sCount, sDurability, nSerialNum) 
VALUES (@strSenderID, @strRecipientID, @strSubject, @strMessage, @bType, @nItemID, @sCount, @sDurability, @nSerialNum)

RETURN 1
GO

CREATE PROCEDURE MAIL_BOX_READ
@strRecipientID char(21),
@nLetterID int
AS

SELECT strMessage FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND nLetterID = @nLetterID
	
IF (@@ROWCOUNT != 0)
BEGIN
	UPDATE MAIL_BOX SET dtReadDate = GETDATE(), bStatus = 2 WHERE nLetterID = @nLetterID AND bType = 1 AND dtReadDate IS NULL
	UPDATE MAIL_BOX SET dtReadDate = GETDATE() WHERE nLetterID = @nLetterID AND bType = 2 AND dtReadDate IS NULL
END
GO

CREATE PROCEDURE MAIL_BOX_GET_ITEM
@strRecipientID char(20),
@nLetterID int
AS

SET NOCOUNT ON

DECLARE @Count int
SELECT @Count = COUNT(strRecipientID) FROM MAIL_BOX WHERE nLetterID = @nLetterID AND bStatus = 1 AND strRecipientID = @strRecipientID
IF @Count = 0
	RETURN 0
	
BEGIN TRAN
	UPDATE MAIL_BOX SET bStatus = 2 WHERE nLetterID = @nLetterID AND bStatus = 1 AND strRecipientID = @strRecipientID
	SELECT nItemID, sCount, sDurability, nCoins, nSerialNum FROM MAIL_BOX WHERE nLetterID = @nLetterID AND bStatus = 2 AND strRecipientID = @strRecipientID
	IF @@ERROR <> 0
	BEGIN	
		ROLLBACK TRAN 
		RETURN 0
	END
COMMIT TRAN

RETURN 1
GO

CREATE PROCEDURE INSERT_USER_DAILY_OP
@strCharID char(21),
@iChaosMapTime int,
@iUserRankRewardTime int,
@iPersonalRankRewardTime int,
@iKingWingTime int,
@iWarderKillerTime1 int,
@iWarderKillerTime2 int,
@iKeeperKillerTime int,
@iUserLoyaltyWingRewardTime int
AS

DELETE FROM USER_DAILY_OP WHERE strUserID = @strCharID
INSERT INTO USER_DAILY_OP (strUserID, ChaosMapTime, UserRankRewardTime, PersonalRankRewardTime, KingWingTime, WarderKillerTime1, WarderKillerTime2, KeeperKillerTime, UserLoyaltyWingRewardTime) VALUES (@strCharID, @iChaosMapTime, @iUserRankRewardTime, @iPersonalRankRewardTime, @iKingWingTime, @iWarderKillerTime1, @iWarderKillerTime2, @iKeeperKillerTime, @iUserLoyaltyWingRewardTime)
GO

CREATE PROCEDURE UPDATE_USER_DAILY_OP
@strCharID char(21),
@bType tinyint,
@iUnixTime int
AS

IF (@bType = 1)
	UPDATE USER_DAILY_OP SET ChaosMapTime = @iUnixTime WHERE strUserID = @strCharID
ELSE IF (@bType = 2)
	UPDATE USER_DAILY_OP SET UserRankRewardTime = @iUnixTime WHERE strUserID = @strCharID
ELSE IF (@bType = 3)
	UPDATE USER_DAILY_OP SET PersonalRankRewardTime = @iUnixTime WHERE strUserID = @strCharID
ELSE IF (@bType = 4)
	UPDATE USER_DAILY_OP SET KingWingTime = @iUnixTime WHERE strUserID = @strCharID
ELSE IF (@bType = 5)
	UPDATE USER_DAILY_OP SET WarderKillerTime1 = @iUnixTime WHERE strUserID = @strCharID
ELSE IF (@bType = 6)
	UPDATE USER_DAILY_OP SET WarderKillerTime2 = @iUnixTime WHERE strUserID = @strCharID
ELSE IF (@bType = 7)
	UPDATE USER_DAILY_OP SET KeeperKillerTime = @iUnixTime WHERE strUserID = @strCharID
ELSE IF (@bType = 8)
	UPDATE USER_DAILY_OP SET UserLoyaltyWingRewardTime = @iUnixTime WHERE strUserID = @strCharID
GO

CREATE PROCEDURE UPDATE_USER_KNIGHTS_RANK
AS
DECLARE @strUserId char(21)
DECLARE @Loyalty int
DECLARE @Knights int
DECLARE @KnightName char(50)
DECLARE @IsValidKnight int
DECLARE @Index smallint
DECLARE @IsValidCount tinyint
DECLARE @RankName varchar(30)
SELECT @IsValidCount = Count(*) FROM USER_KNIGHTS_RANK
IF @IsValidCount < 100
BEGIN

    SET @Index = 1

    WHILE @Index < 101
    BEGIN

        IF @Index = 1
        BEGIN
            SET @RankName = 'Gold Knight'
        END
        IF @Index > 1 AND @Index <= 4
        BEGIN
            SET @RankName = 'Silver Knight'
        END
        IF @Index > 4 AND @Index <= 9
        BEGIN
            SET @RankName = 'Mirage Knight'
        END
        IF @Index > 9 AND @Index <= 10
        BEGIN
            SET @RankName = 'Shadow Knight'
        END
        IF @Index > 25 AND @Index <= 50
        BEGIN
            SET @RankName = 'Mist Knight'
        END
        IF @Index > 50 AND @Index <= 100
        BEGIN
            SET @RankName = 'Training Knight'
        END
       
        INSERT INTO USER_KNIGHTS_RANK (shIndex,strName,strElmoUserID,strElmoKnightsName,nElmoLoyalty,strKarusUserID,strKarusKnightsName,nKarusLoyalty,nMoney) VALUES (@Index,@RankName,NULL,NULL,0,NULL,NULL,0,1000000)
   
        SET @Index = @Index + 1
    END
END

SET @Index = 1
SET @strUserId = NULL
SET @Loyalty = 0
SET @Knights = 0
DECLARE RANKING_CRS CURSOR FOR
SELECT TOP 100 strUserId,Loyalty,Knights FROM USERDATA WHERE Nation = 1 AND Authority = 1 AND Knights <> 0 ORDER BY Loyalty DESC

OPEN RANKING_CRS
FETCH NEXT FROM RANKING_CRS INTO @strUserId,@Loyalty,@Knights
WHILE @@FETCH_STATUS = 0 
BEGIN

SET @KnightName = NULL
SET @IsValidKnight = 0
IF @Knights <> 0
BEGIN
    SELECT @IsValidKnight = COUNT(IDName) FROM KNIGHTS WHERE IDNum = @Knights
   
    IF @IsValidKnight <> 0
    BEGIN
        SELECT @KnightName = IDName FROM KNIGHTS WHERE IDNum = @Knights
    END
END
   
    UPDATE USER_KNIGHTS_RANK SET strKarusUserID = @strUserId, strKarusKnightsName = @KnightName, nKarusLoyalty = @Loyalty WHERE shIndex = @Index
   
    SET @Index = @Index + 1
            
FETCH NEXT FROM RANKING_CRS INTO @strUserId,@Loyalty,@Knights
END
CLOSE RANKING_CRS
DEALLOCATE RANKING_CRS

SET @Index = 1
SET @strUserId = NULL
SET @Loyalty = 0
SET @Knights = 0
DECLARE RANKING_CRS CURSOR FOR
SELECT TOP 100 strUserId,Loyalty,Knights FROM USERDATA WHERE Nation = 2 AND Authority = 1 AND Knights <> 0 ORDER BY Loyalty DESC

OPEN RANKING_CRS
FETCH NEXT FROM RANKING_CRS INTO @strUserId,@Loyalty,@Knights
WHILE @@FETCH_STATUS = 0 
BEGIN

SET @KnightName = NULL
SET @IsValidKnight = 0
IF @Knights <> 0
BEGIN
    SELECT @IsValidKnight = COUNT(IDName) FROM KNIGHTS WHERE IDNum = @Knights
   
    IF @IsValidKnight <> 0
    BEGIN
        SELECT @KnightName = IDName FROM KNIGHTS WHERE IDNum = @Knights
    END
END
   
    UPDATE USER_KNIGHTS_RANK SET strElmoUserID = @strUserId, strElmoKnightsName = @KnightName, nElmoLoyalty = @Loyalty WHERE shIndex = @Index
   
    SET @Index = @Index + 1
            
FETCH NEXT FROM RANKING_CRS INTO @strUserId,@Loyalty,@Knights
END
CLOSE RANKING_CRS
DEALLOCATE RANKING_CRS
GO

CREATE PROCEDURE UPDATE_USER_PERSONAL_RANK
AS
BEGIN TRAN
DECLARE @strUserId char(21)
DECLARE @LoyaltyMonthly int
DECLARE @Index smallint
DECLARE @IsValidCount tinyint
DECLARE @RankName varchar(30)
DECLARE @DifferenceBetweenUser int

SELECT @IsValidCount = Count(*) FROM USER_PERSONAL_RANK
IF @IsValidCount < 200
BEGIN
   
	TRUNCATE TABLE USER_PERSONAL_RANK
    SET @Index = 1

    WHILE @Index < 201
    BEGIN

        IF @Index = 1
        BEGIN
            SET @RankName = 'Gold Knight'
        END
        IF @Index > 1 AND @Index <= 4
        BEGIN
            SET @RankName = 'Silver Knight'
        END
        IF @Index > 4 AND @Index <= 9
        BEGIN
            SET @RankName = 'Mirage Knight'
        END
        IF @Index > 9 AND @Index <= 10
        BEGIN
            SET @RankName = 'Shadow Knight'
        END
        IF @Index > 25 AND @Index <= 100
        BEGIN
            SET @RankName = 'Mist Knight'
        END
		IF @Index > 100 AND @Index <= 200
        BEGIN
            SET @RankName = 'Training Knight'
        END
       
        INSERT INTO USER_PERSONAL_RANK (nRank,strPosition,nElmoUP,strElmoUserID,nElmoLoyaltyMonthly,nElmoCheck,nKarusUP,strKarusUserID,nKarusLoyaltyMonthly,nKarusCheck,nSalary,UpdateDate) VALUES (@Index,@RankName,0,NULL,0,1000000,0,NULL,0,1000000,1000000,GETDATE())
           
        SET @Index = @Index + 1
    END
END

SET @Index = 1
SET @strUserId = NULL
SET @LoyaltyMonthly = 0
DECLARE RANKING_CRS CURSOR FOR
SELECT TOP 200 strUserId,LoyaltyMonthly FROM USERDATA WHERE Nation = 1 AND Authority = 1 AND Knights <> 0 ORDER BY LoyaltyMonthly DESC

OPEN RANKING_CRS
FETCH NEXT FROM RANKING_CRS INTO @strUserId,@LoyaltyMonthly
WHILE @@FETCH_STATUS = 0 
BEGIN
    
    UPDATE USER_PERSONAL_RANK SET strKarusUserID = @strUserId, nKarusUP = @Index, nKarusLoyaltyMonthly = @LoyaltyMonthly WHERE nRank = @Index
   
    SET @DifferenceBetweenUser = 0
   
    IF @Index = 1
    BEGIN
   
        UPDATE USER_PERSONAL_RANK SET nKarusCheck = 0 WHERE nRank = @Index
   
    END
    ELSE
    BEGIN
   
        SELECT @DifferenceBetweenUser = nKarusLoyaltyMonthly FROM USER_PERSONAL_RANK WHERE nRank = @Index + 1
   
        SET @DifferenceBetweenUser = @LoyaltyMonthly - @DifferenceBetweenUser
   
        UPDATE USER_PERSONAL_RANK SET nKarusCheck = @DifferenceBetweenUser WHERE nRank = @Index + 1
       
    END
       
    SET @Index = @Index + 1
            
FETCH NEXT FROM RANKING_CRS INTO @strUserId,@LoyaltyMonthly
END
CLOSE RANKING_CRS
DEALLOCATE RANKING_CRS

SET @Index = 1
SET @strUserId = NULL
SET @LoyaltyMonthly = 0
DECLARE RANKING_CRS CURSOR FOR
SELECT TOP 200 strUserId,LoyaltyMonthly FROM USERDATA WHERE Nation = 2 AND Authority = 1 AND Knights <> 0 ORDER BY LoyaltyMonthly DESC

OPEN RANKING_CRS
FETCH NEXT FROM RANKING_CRS INTO @strUserId,@LoyaltyMonthly
WHILE @@FETCH_STATUS = 0 
BEGIN
   
    UPDATE USER_PERSONAL_RANK SET strElmoUserID = @strUserId, nElmoUP = @Index, nElmoLoyaltyMonthly = @LoyaltyMonthly WHERE nRank = @Index   
   
    SET @DifferenceBetweenUser = 0
   
    IF @Index = 1
    BEGIN
   
        UPDATE USER_PERSONAL_RANK SET nElmoCheck = 0 WHERE nRank = @Index
   
    END
    ELSE
    BEGIN
   
        SELECT @DifferenceBetweenUser = nElmoLoyaltyMonthly FROM USER_PERSONAL_RANK WHERE nRank = @Index + 1
   
        SET @DifferenceBetweenUser = @LoyaltyMonthly - @DifferenceBetweenUser
   
        UPDATE USER_PERSONAL_RANK SET nElmoCheck = @DifferenceBetweenUser WHERE nRank = @Index + 1
       
    END
   
    SET @Index = @Index + 1
            
FETCH NEXT FROM RANKING_CRS INTO @strUserId,@LoyaltyMonthly
END
CLOSE RANKING_CRS
DEALLOCATE RANKING_CRS

UPDATE USER_PERSONAL_RANK SET nSalary = REPLACE(nElmoLoyaltyMonthly - nKarusLoyaltyMonthly,'-','')

COMMIT TRAN
GO

CREATE PROCEDURE UPDATE_KNIGHTS_RATING
AS
BEGIN
	TRUNCATE TABLE KNIGHTS_RATING

	UPDATE KNIGHTS SET 
		Points = (SELECT ISNULL(SUM(Loyalty), 0) FROM USERDATA WHERE Knights = IDNum),
		ClanPointFund = (SELECT ISNULL(SUM(nDonatedNP), 0) FROM KNIGHTS_USER WHERE sIDNum = IDNum)

	INSERT INTO KNIGHTS_RATING 
		SELECT ROW_NUMBER() OVER (ORDER BY ClanPointFund DESC, Points DESC), IDNum, IDName, Points, ClanPointFund FROM KNIGHTS ORDER BY ClanPointFund DESC, Points DESC

	UPDATE KNIGHTS SET Ranking = 0 WHERE Ranking != 0
	UPDATE KNIGHTS SET Ranking = (SELECT nRank FROM KNIGHTS_RATING WHERE shIndex = IDNum AND nRank <= 5) WHERE (SELECT nRank FROM KNIGHTS_RATING WHERE shIndex = IDNum AND nRank <= 5) <= 5
END
GO

CREATE PROCEDURE RESET_LOYALTY_MONTHLY
AS

UPDATE USERDATA SET LoyaltyMonthly = 0 WHERE LoyaltyMonthly > 0
GO

CREATE PROCEDURE UPDATE_RANKS
AS

EXEC UPDATE_USER_KNIGHTS_RANK
EXEC UPDATE_USER_PERSONAL_RANK
EXEC UPDATE_KNIGHTS_RATING

GO