/*
 * Close all active sessions by calling the stored procedure
 * CloseActiveSessions() passing 7200 (2 hours) as the session
 * length to account.
 */

EXEC [WhosOn].[dbo].[CloseActiveSessions] @length = 7200
