/*
 * Delete builtin account registrations. These are probably added
 * at client installation and should be ignored.
 */ 
DELETE FROM [WhosOn].[dbo].[Logons]
WHERE	Username = 'SYSTEM' AND
		Domain LIKE 'NT AUTHORI%'
		
/* 
 * Delete registrations for non-domain logons.
 */
 DELETE FROM [WhosOn].[dbo].[Logons]
 WHERE	Domain IS NULL OR
		Domain = ''
 