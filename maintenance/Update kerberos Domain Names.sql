/*
 * Remap USER.UU.SE (kerberos) -> USER (active directory)
 */
UPDATE [WhosOn].[dbo].[Logons]
SET Domain = 'USER' WHERE Domain = 'USER.UU.SE'
