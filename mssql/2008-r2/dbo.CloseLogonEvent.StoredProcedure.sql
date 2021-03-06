USE [WhosOn]
GO
/****** Object:  StoredProcedure [dbo].[CloseLogonEvent]    Script Date: 11/23/2011 02:09:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
 * Description:
 * 
 *   Updates the related logon event in the database by setting the end time
 *   value for an existing logon event. The related @event_id argument can be 
 *   found by calling GetLogonEvent() prior to calling this function.
 *
 * Return: 
 *
 *   The last error code on failure and 0 if successful.
 *
 * Author: Anders Lövgren
 * Date:   2011-10-22
 */
CREATE PROCEDURE [dbo].[CloseLogonEvent]
( 
	@event_id	INT		/* The event ID */
)
AS

SET NOCOUNT ON;

BEGIN
	UPDATE Logons SET EndTime = CURRENT_TIMESTAMP WHERE ID = @event_id
	IF @@error <> 0 BEGIN
		RETURN @@error
	END
END

RETURN 0
GO
