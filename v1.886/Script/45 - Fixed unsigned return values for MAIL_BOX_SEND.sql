ALTER PROCEDURE MAIL_BOX_SEND
@strSenderID char(20),
@strRecipientID char(20),
@strSubject char(31),
@strMessage char(128),
@bType tinyint,
@nItemID int,
@sCount smallint,
@sDurability smallint,
@nSerialNum bigint,
@bRet tinyint OUTPUT
AS
-- =============================================
-- Return values: 
--	250 - You cannot send a letter to yourself.
--	251 - Exceeded the allowed limit for sending coins.
--	252 - There's not enough coins in the bag.
--	253 - You do not have enough money for postage.
--	
--	254 - (Dialog)The receiver's mailbox is full.
--			Please try sending your letter at a time.
--		
--			*If you buy a premium service, 
--			you'll be able to receive up to
--	
--	255 - Failed sending letter.
-- =============================================
DECLARE @isValidUser tinyint, @bPremiumType tinyint, @bCount tinyint, @bLimitLine tinyint

SELECT @isValidUser = COUNT(*) FROM USERDATA WHERE strUserID = @strRecipientID

IF (@isValidUser = 0)
BEGIN
	SET @bRet = 255
	RETURN
END

SELECT @bPremiumType = PremiumType FROM TB_USER WHERE strAccountID = @strRecipientID

IF (@bPremiumType != 0)
	SET @bLimitLine = 20
ELSE
	SET @bLimitLine = 10

SELECT @bCount = COUNT(*) FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND bStatus = 1 AND bDeleted = 0

IF (@bCount >= @bLimitLine)
BEGIN
	SET @bRet = 254
	RETURN
END

IF (@strSenderID = @strRecipientID)
BEGIN
	SET @bRet = 250
	RETURN
END

INSERT INTO MAIL_BOX (strSenderID, strRecipientID, strSubject, strMessage, bType, nItemID, sCount, sDurability, nSerialNum) 
VALUES (@strSenderID, @strRecipientID, @strSubject, @strMessage, @bType, @nItemID, @sCount, @sDurability, @nSerialNum)

SET @bRet = 1
GO