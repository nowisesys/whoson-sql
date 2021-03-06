USE [WhosOn]
GO
/****** Object:  StoredProcedure [dbo].[CreateLogonEvent]    Script Date: 11/23/2011 02:09:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
 * Description:
 * 
 *   Inserts an logon event in the database. The caller should ensure that no 
 *   previous logon event exist with the same characteristics (from argument 
 *   list).
 *
 *   The ID of the newly inserted logon event is passed as an output parameter 
 *   in @event_id.
 *
 * Return: 
 *
 *   The last error code on failure and 0 if successful.
 * 
 * Author: Anders Lövgren
 * Date:   2011-10-22
 */
CREATE PROCEDURE [dbo].[CreateLogonEvent]
( 
	@username	VARCHAR(20),		/* Logon username */
	@domain		VARCHAR(10),		/* Logon domain */
	@hwaddr		NCHAR(17) = NULL,	/* MAC-address */
	@ipaddr		NVARCHAR(46),		/* IPv4 or IPv6 address */
	@hostname	NVARCHAR(50),		/* DNS hostname (FQHN) */
	@wksta		VARCHAR(50),		/* NetBIOS name */
	@event_id	INT	OUTPUT			/* The event ID */
)
AS

SET NOCOUNT ON;

BEGIN
	INSERT INTO Logons(Username, Domain, HwAddress, IpAddress, Hostname, Workstation, Starttime)
	VALUES(@username, @domain, @hwaddr, @ipaddr, @hostname, @wksta, CURRENT_TIMESTAMP);
	IF @@error <> 0 BEGIN
		RETURN @@error
	END
END

SET @event_id = SCOPE_IDENTITY()
RETURN 0
GO
