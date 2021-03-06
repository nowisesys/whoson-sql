USE [WhosOn]
GO
/****** Object:  StoredProcedure [dbo].[GetLogonData]    Script Date: 11/23/2011 02:09:02 ******/
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
 *   The data associated with the logon event ID.
 * 
 * Author: Anders Lövgren
 * Date:   2011-11-22
 */
CREATE PROCEDURE [dbo].[GetLogonData] 
	@event_id INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Logons
	WHERE ID = @event_id
END
GO
