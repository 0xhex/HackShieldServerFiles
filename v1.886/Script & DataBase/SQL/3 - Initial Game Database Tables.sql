SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ACCOUNT_CHAR')
    DROP TABLE ACCOUNT_CHAR;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EVENT')
    DROP TABLE EVENT;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EVENT_TRIGGER')
    DROP TABLE EVENT_TRIGGER;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ITEM_OP')
    DROP TABLE ITEM_OP;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'KNIGHTS')
    DROP TABLE KNIGHTS;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'KNIGHTS_CAPE')
    DROP TABLE KNIGHTS_CAPE;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'KNIGHTS_USER')
    DROP TABLE KNIGHTS_USER;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'KNIGHTS_RATING')
DROP TABLE KNIGHTS_RATING;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MAIL_BOX')
    DROP TABLE MAIL_BOX;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MONSTER_CHALLENGE')
    DROP TABLE MONSTER_CHALLENGE;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MONSTER_CHALLENGE_SUMMON_LIST')
    DROP TABLE MONSTER_CHALLENGE_SUMMON_LIST;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MONSTER_RESPAWN_LIST')
    DROP TABLE MONSTER_RESPAWN_LIST;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MONSTER_RESPAWN_LIST_INFORMATION')
    DROP TABLE MONSTER_RESPAWN_LIST_INFORMATION;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MONSTER_SUMMON_LIST')
    DROP TABLE MONSTER_SUMMON_LIST;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MONSTER_SUMMON_LIST_ZONE')
    DROP TABLE MONSTER_SUMMON_LIST_ZONE;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PREMIUM_ITEM')
    DROP TABLE PREMIUM_ITEM;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PREMIUM_ITEM_EXP')
    DROP TABLE PREMIUM_ITEM_EXP;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'QUEST_HELPER')
    DROP TABLE QUEST_HELPER;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'QUEST_MONSTER')
    DROP TABLE QUEST_MONSTER;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SEALED_ITEMS')
    DROP TABLE SEALED_ITEMS;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SET_ITEM')
    DROP TABLE SET_ITEM;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'START_POSITION')
    DROP TABLE START_POSITION;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'START_POSITION_RANDOM')
    DROP TABLE START_POSITION_RANDOM;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SERVER_RESOURCE')
    DROP TABLE SERVER_RESOURCE;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'USER_DAILY_OP')
    DROP TABLE USER_DAILY_OP;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'USERDATA')
    DROP TABLE USERDATA;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WAREHOUSE')
    DROP TABLE WAREHOUSE;
IF NOT EXISTS(SELECT * FROM sys.columns WHERE NAME = N'UseStanding' AND Object_ID = OBJECT_ID(N'MAGIC'))
	ALTER TABLE MAGIC ADD UseStanding tinyint NOT NULL DEFAULT 0
IF EXISTS(SELECT * FROM sys.columns WHERE NAME = N'sLightR' AND Object_ID = OBJECT_ID(N'K_NPC'))
	ALTER TABLE K_NPC DROP COLUMN sLightR
IF EXISTS(SELECT * FROM sys.columns WHERE NAME = N'byMoneyType' AND Object_ID = OBJECT_ID(N'K_NPC'))
	ALTER TABLE K_NPC DROP COLUMN byMoneyType
IF EXISTS(SELECT * FROM sys.columns WHERE NAME = N'sLightR' AND Object_ID = OBJECT_ID(N'K_MONSTER'))
	ALTER TABLE K_MONSTER DROP COLUMN sLightR
IF EXISTS(SELECT * FROM sys.columns WHERE NAME = N'byMoneyType' AND Object_ID = OBJECT_ID(N'K_MONSTER'))
	ALTER TABLE K_MONSTER DROP COLUMN byMoneyType
GO

CREATE TABLE ACCOUNT_CHAR(
	strAccountID char(21) NOT NULL,
	bNation tinyint NOT NULL,
	bCharNum tinyint NOT NULL DEFAULT 0,
	strCharID1 char(21) NULL,
	strCharID2 char(21) NULL,
	strCharID3 char(21) NULL
)
GO

CREATE TABLE EVENT(
	[ZoneNum] [tinyint] NOT NULL,
	[EventNum] [smallint] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[Cond1] [char](128) NULL,
	[Cond2] [char](128) NULL,
	[Cond3] [char](128) NULL,
	[Cond4] [char](128) NULL,
	[Cond5] [char](128) NULL,
	[Exec1] [char](128) NULL,
	[Exec2] [char](128) NULL,
	[Exec3] [char](128) NULL,
	[Exec4] [char](128) NULL,
	[Exec5] [char](128) NULL
)
GO

CREATE TABLE EVENT_TRIGGER (
	[nIndex] [int] NULL,
	[bNpcType] [smallint] NULL,
	[sNpcID] [int] NULL,
	[nTriggerNum] [int] NULL
)
GO

CREATE TABLE ITEM_OP(
	nItemID int NOT NULL,
	bTriggerType tinyint NOT NULL,
	nSkillID int NOT NULL,
	bTriggerRate tinyint NOT NULL
)
GO

CREATE TABLE KNIGHTS(
	IDNum smallint NOT NULL,
	Flag tinyint NOT NULL,
	Nation tinyint NOT NULL,
	Ranking tinyint NOT NULL DEFAULT 0,
	IDName char(21) NOT NULL,
	Members smallint NOT NULL DEFAULT 1,
	Chief char(21) NOT NULL,
	ViceChief_1 char(21) NULL,
	ViceChief_2 char(21) NULL,
	ViceChief_3 char(21) NULL,
	Gold bigint NOT NULL DEFAULT 0,
	Domination smallint NOT NULL DEFAULT 0,
	Points int NOT NULL DEFAULT 0,
	Mark image NULL,
	sMarkVersion smallint NOT NULL DEFAULT 0,
	sMarkLen smallint NOT NULL DEFAULT 0,
	sCape smallint NOT NULL DEFAULT -1,
	bCapeR tinyint NOT NULL DEFAULT 0,
	bCapeG tinyint NOT NULL DEFAULT 0,
	bCapeB tinyint NOT NULL DEFAULT 0,
	sAllianceKnights smallint NOT NULL DEFAULT 0,
	ClanPointFund int NOT NULL DEFAULT 0,
	strClanNotice char(128) NULL,
	ClanPointMethod tinyint NOT NULL DEFAULT 0,
	dtCreateTime datetime NOT NULL DEFAULT GETDATE()
)
GO

CREATE TABLE KNIGHTS_CAPE(
	sCapeIndex smallint NOT NULL,
	strName char(30) NOT NULL,
	nBuyPrice int NOT NULL,
	nDuration int NOT NULL,
	byGrade tinyint NOT NULL,
	nBuyLoyalty int NOT NULL,
	byRanking tinyint NOT NULL
)
GO

CREATE TABLE KNIGHTS_USER(
	sIDNum smallint NOT NULL,
	strUserID char(21) NOT NULL,
	nDonatedNP int NOT NULL DEFAULT 0
)

GO

CREATE TABLE KNIGHTS_RATING(
	[nRank] [int] NOT NULL,
	[shIndex] [smallint] NOT NULL,
	[strName] [char](20) NOT NULL,
	[nPoints] [int] NOT NULL,
	[nClanPointFund] [int] NOT NULL
) ON [PRIMARY]

GO

CREATE TABLE MAIL_BOX(
	nLetterID int IDENTITY(1,1) NOT NULL,
	dtSendDate datetime NOT NULL DEFAULT GETDATE(),
	dtReadDate datetime NULL,
	bStatus tinyint NOT NULL DEFAULT 1,
	strSenderID char(21) NOT NULL,
	strRecipientID char(21) NOT NULL,
	strSubject char(31) NOT NULL,
	strMessage char(128) NOT NULL,
	bType tinyint NOT NULL DEFAULT 1,
	nItemID int NOT NULL DEFAULT 0,
	sCount smallint NOT NULL DEFAULT 0,
	sDurability smallint NOT NULL DEFAULT 0,
	nSerialNum bigint NOT NULL DEFAULT 0,
	nCoins int NOT NULL DEFAULT 0,
	bDeleted bit NOT NULL DEFAULT 0,
PRIMARY KEY CLUSTERED 
(
	nLetterID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90)
)
GO

CREATE TABLE MONSTER_CHALLENGE(
	sIndex smallint NOT NULL,
	bStartTime1 tinyint NOT NULL,
	bStartTime2 tinyint NOT NULL,
	bStartTime3 tinyint NOT NULL,
	bLevelMin tinyint NOT NULL,
	bLevelMax tinyint NOT NULL
)
GO

CREATE TABLE MONSTER_CHALLENGE_SUMMON_LIST(
	sIndex smallint NOT NULL,
	bLevel tinyint NOT NULL,
	bStage tinyint NOT NULL,
	bStageLevel tinyint NOT NULL,
	sTime smallint NOT NULL,
	sSid smallint NOT NULL,
	strName varchar(50) NULL,
	sCount smallint NOT NULL,
	sPosX smallint NOT NULL,
	sPosZ smallint NOT NULL,
	bRange tinyint NOT NULL
)
GO

CREATE TABLE MONSTER_RESPAWN_LIST(
	sIndex smallint NOT NULL,
	sSid smallint NOT NULL,
	sCount smallint NOT NULL
)
GO

CREATE TABLE MONSTER_RESPAWN_LIST_INFORMATION(
	sIndex smallint NULL,
	sSid smallint NULL,
	ZoneID tinyint NULL,
	bType tinyint NULL,
	X smallint NULL,
	Y smallint NULL,
	Z smallint NULL,
	sCount smallint NULL,
	bRadius tinyint NULL
)
GO

CREATE TABLE MONSTER_SUMMON_LIST(
	sSid smallint NOT NULL,
	strName varchar(30) NULL,
	sLevel smallint NOT NULL,
	sProbability smallint NOT NULL,
	bType tinyint NOT NULL
)
GO

CREATE TABLE MONSTER_SUMMON_LIST_ZONE(
	nIndex int NOT NULL,
	ZoneID smallint NOT NULL,
	sSid smallint NOT NULL,
	strName varchar(50) NULL,
	byFamily tinyint NOT NULL
)
GO

CREATE TABLE PREMIUM_ITEM(
	[Type] tinyint NOT NULL,
	ExpRestorePercent smallint NOT NULL,
	NoahPercent smallint NOT NULL,
	DropPercent smallint NOT NULL,
	BonusLoyalty int NOT NULL,
	RepairDiscountPercent smallint NOT NULL,
	ItemSellPercent smallint NOT NULL
)
GO

CREATE TABLE PREMIUM_ITEM_EXP(
	nIndex smallint NOT NULL,
	[Type] tinyint NOT NULL,
	MinLevel tinyint NOT NULL,
	MaxLevel tinyint NOT NULL,
	sPercent smallint NOT NULL
)
GO

CREATE TABLE QUEST_HELPER(
	nIndex int NOT NULL,
	bMessageType tinyint NOT NULL,
	bLevel tinyint NOT NULL,
	nExp int NOT NULL,
	bClass tinyint NOT NULL,
	bNation tinyint NOT NULL,
	bQuestType tinyint NOT NULL,
	bZone tinyint NOT NULL,
	sNpcId smallint NOT NULL,
	sEventDataIndex smallint NOT NULL,
	bEventStatus tinyint NOT NULL,
	nEventTriggerIndex int NOT NULL,
	nEventCompleteIndex int NOT NULL,
	nExchangeIndex int NOT NULL,
	nEventTalkIndex int NOT NULL,
	strLuaFilename char(40) NOT NULL
)
GO

CREATE TABLE QUEST_MONSTER(
	sQuestNum smallint NOT NULL,
	sNum1a smallint NOT NULL,
	sNum1b smallint NOT NULL,
	sNum1c smallint NOT NULL,
	sNum1d smallint NOT NULL,
	sCount1 smallint NOT NULL,
	sNum2a smallint NOT NULL,
	sNum2b smallint NOT NULL,
	sNum2c smallint NOT NULL,
	sNum2d smallint NOT NULL,
	sCount2 smallint NOT NULL,
	sNum3a smallint NOT NULL,
	sNum3b smallint NOT NULL,
	sNum3c smallint NOT NULL,
	sNum3d smallint NOT NULL,
	sCount3 smallint NOT NULL,
	sNum4a smallint NOT NULL,
	sNum4b smallint NOT NULL,
	sNum4c smallint NOT NULL,
	sNum4d smallint NOT NULL,
	sCount4 smallint NOT NULL
)
GO

CREATE TABLE SEALED_ITEMS(
	ID int IDENTITY(1,1) NOT NULL,
	strAccountID char(21) NOT NULL,
	strUserID char(21) NOT NULL,
	nItemSerial bigint NOT NULL,
	nItemID int NOT NULL,
	bSealType tinyint NOT NULL,
 PRIMARY KEY CLUSTERED 
(
	ID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90)
)
GO

CREATE TABLE SET_ITEM(
	SetIndex int NOT NULL,
	SetName varchar(50) NULL,
	ACBonus smallint NOT NULL,
	HPBonus smallint NOT NULL,
	MPBonus smallint NOT NULL,
	StrengthBonus smallint NOT NULL,
	StaminaBonus smallint NOT NULL,
	DexterityBonus smallint NOT NULL,
	IntelBonus smallint NOT NULL,
	CharismaBonus smallint NOT NULL,
	FlameResistance smallint NOT NULL,
	GlacierResistance smallint NOT NULL,
	LightningResistance smallint NOT NULL,
	PoisonResistance smallint NOT NULL,
	MagicResistance smallint NOT NULL,
	CurseResistance smallint NOT NULL,
	XPBonusPercent smallint NOT NULL,
	CoinBonusPercent smallint NOT NULL,
	APBonusPercent smallint NOT NULL,
	APBonusClassType smallint NOT NULL,
	APBonusClassPercent smallint NOT NULL,
	ACBonusClassType smallint NOT NULL,
	ACBonusClassPercent smallint NOT NULL,
	MaxWeightBonus smallint NOT NULL,
	NPBonus tinyint NOT NULL,
	Unk10 tinyint NOT NULL,
	Unk11 tinyint NOT NULL,
	Unk12 tinyint NOT NULL,
	Unk13 tinyint NOT NULL,
	Unk14 tinyint NOT NULL,
	Unk15 tinyint NOT NULL,
	Unk16 tinyint NOT NULL,
	Unk17 tinyint NOT NULL,
	Unk18 tinyint NOT NULL,
	Unk19 tinyint NOT NULL,
	Unk20 tinyint NOT NULL,
	Unk21 tinyint NOT NULL
)
GO

CREATE TABLE START_POSITION(
	[ZoneID] [smallint] NOT NULL,
	[sKarusX] [smallint] NOT NULL,
	[sKarusZ] [smallint] NOT NULL,
	[sElmoradX] [smallint] NOT NULL,
	[sElmoradZ] [smallint] NOT NULL,
	[sKarusGateX] [smallint] NULL,
	[sKarusGateZ] [smallint] NULL,
	[sElmoGateX] [smallint] NULL,
	[sElmoGateZ] [smallint] NULL,
	[bRangeX] [tinyint] NOT NULL,
	[bRangeZ] [tinyint] NOT NULL
)
GO

CREATE TABLE START_POSITION_RANDOM(
	ZoneID tinyint NULL,
	PosX smallint NULL,
	PosZ smallint NULL,
	Radius tinyint NULL
)
GO

CREATE TABLE SERVER_RESOURCE(
	[nResourceID] [int] NOT NULL,
	[strResource] [varchar](250) NOT NULL
) 
GO

CREATE TABLE USER_DAILY_OP(
	strUserID char(21) NOT NULL,
	ChaosMapTime int NOT NULL,
	UserRankRewardTime int NOT NULL,
	PersonalRankRewardTime int NOT NULL,
	KingWingTime int NOT NULL,
	WarderKillerTime1 int NOT NULL,
	WarderKillerTime2 int NOT NULL,
	KeeperKillerTime int NOT NULL,
	UserLoyaltyWingRewardTime int NOT NULL
)
GO

CREATE TABLE USERDATA(
	strUserID char(21) NOT NULL,
	Nation tinyint NOT NULL,
	Race tinyint NOT NULL,
	Class smallint NOT NULL,
	HairRGB int NOT NULL,
	[Rank] tinyint NOT NULL DEFAULT 0,
	Title tinyint NOT NULL DEFAULT 0,
	[Level] tinyint NOT NULL DEFAULT 1,
	[Exp] bigint NOT NULL DEFAULT 0,
	Loyalty int NOT NULL DEFAULT 100,
	Face tinyint NOT NULL,
	City tinyint NOT NULL DEFAULT 0,
	Knights smallint NOT NULL DEFAULT 0,
	Fame tinyint NOT NULL DEFAULT 0,
	Hp smallint NOT NULL DEFAULT 100,
	Mp smallint NOT NULL DEFAULT 100,
	Sp smallint NOT NULL DEFAULT 100,
	Strong tinyint NOT NULL,
	Sta tinyint NOT NULL,
	Dex tinyint NOT NULL,
	Intel tinyint NOT NULL,
	Cha tinyint NOT NULL,
	Authority tinyint NOT NULL DEFAULT 1,
	Points smallint NOT NULL DEFAULT 0,
	Gold int NOT NULL DEFAULT 0,
	Zone tinyint NOT NULL DEFAULT 21,
	Bind smallint NULL,
	PX int NOT NULL DEFAULT 81590,
	PZ int NOT NULL DEFAULT 53079,
	PY int NOT NULL DEFAULT 469,
	dwTime int NOT NULL DEFAULT 0,
	strSkill varchar(10) NULL,
	strItem binary(584) NULL,
	strSerial binary(584) NULL,
	sQuestCount smallint NOT NULL DEFAULT 0,
	strQuest binary(600) NULL,
	MannerPoint int NOT NULL DEFAULT 0,
	LoyaltyMonthly int NOT NULL DEFAULT 0,
	dtCreateTime datetime NOT NULL DEFAULT GETDATE(),
	dtUpdateTime datetime NULL
)
GO

CREATE TABLE WAREHOUSE(
	strAccountID char(21) NOT NULL,
	nMoney int NOT NULL DEFAULT 0,
	dwTime int NOT NULL DEFAULT 0,
	WarehouseData binary(1536) NULL,
	strSerial binary(1536) NULL
)
GO