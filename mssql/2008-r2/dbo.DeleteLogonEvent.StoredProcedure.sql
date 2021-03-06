USE [WhosOn]
GO
/****** Object:  StoredProcedure [dbo].[DeleteLogonEvent]    Script Date: 11/23/2011 02:09:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
 * Description:
 * 
 *   Delete logon event.
 *
 * Author: Anders Lövgren
 * Date:   2011-10-22
 */

CREATE PROCEDURE [dbo].[DeleteLogonEvent]
(
	@event_id	INT
)
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM Logons WHERE ID = @event_id
END
GO
