SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
TRUNCATE TABLE USERDATA
TRUNCATE TABLE ACCOUNT_CHAR
TRUNCATE TABLE USER_SAVED_MAGIC
TRUNCATE TABLE USERDATA_SKILLSHORTCUT
TRUNCATE TABLE FRIEND_LIST
TRUNCATE TABLE KNIGHTS_RATING
TRUNCATE TABLE KNIGHTS_USER
TRUNCATE TABLE KNIGHTS
TRUNCATE TABLE KNIGHTS_ALLIANCE
TRUNCATE TABLE SEALED_ITEMS
TRUNCATE TABLE USER_DAILY_OP
TRUNCATE TABLE USER_KNIGHTS_RANK
TRUNCATE TABLE USER_PERSONAL_RANK
TRUNCATE TABLE WAREHOUSE
TRUNCATE TABLE WEB_ITEMMALL
TRUNCATE TABLE WEB_ITEMMALL_LOG
TRUNCATE TABLE KING_CANDIDACY_NOTICE_BOARD
TRUNCATE TABLE KING_ELECTION_LIST
TRUNCATE TABLE KING_BALLOT_BOX
TRUNCATE TABLE KING_SYSTEM

INSERT INTO KING_SYSTEM VALUES (1,7,2008,4,27,1,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000000000,0,NULL,NULL)
INSERT INTO KING_SYSTEM VALUES (2,7,2008,4,27,1,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000000000,0,NULL,NULL)

EXEC UPDATE_USER_KNIGHTS_RANK
EXEC UPDATE_USER_PERSONAL_RANK
EXEC UPDATE_KNIGHTS_RATING