USE [WhosOn]
GO
/****** Object:  StoredProcedure [dbo].[FindLogonEvent]    Script Date: 11/23/2011 02:09:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
 * Description:
 * 
 *   Get data for an existing logon event.
 *
 * Return: 
 *
 *   The logon event data or null if logon session is missing.
 * 
 * Author: Anders Lövgren
 * Date:   2011-10-22
 */
CREATE PROCEDURE [dbo].[FindLogonEvent]
	@username	VARCHAR(20),		/* Logon username */
	@domain		VARCHAR(16),		/* Logon domain */
	@ipaddr		NVARCHAR(46)		/* IPv4 or IPv6 address */
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM Logons 
	WHERE	Username = @username AND
			Domain = @domain AND
			IpAddress = @ipaddr AND
			EndTime IS NULL
END
GO
