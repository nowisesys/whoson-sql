USE [WhosOn]
GO
/****** Object:  StoredProcedure [dbo].[CloseActiveSessions]    Script Date: 04/20/2012 16:28:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
 * Description:
 * 
 *   Close all active sessions by setting "endtime = starttime + length".
 *   The @length parameter is session length to account, measured in 
 *   seconds.
 *
 * Author: Anders Lövgren
 * Date:   2012-04-20
 */
CREATE PROCEDURE [dbo].[CloseActiveSessions]
( 
	@length	INT		/* Session length in seconds to account */
)
AS

SET NOCOUNT ON;

BEGIN
	UPDATE Logons SET EndTime = DATEADD(SS, @length, StartTime)
	WHERE EndTime IS NULL
END
