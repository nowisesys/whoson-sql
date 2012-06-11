/* 
 * Truncate sessions whos length are longer than 12 hours. 
 *
 * This should normally not happens, unless the WhosOn client failed to
 * run at logout. Reason for this could be inproper configuration of a
 * GPO (group policy object) in active directory.
 */

UPDATE Logons SET EndTime = DATEADD(HH, 12, StartTime)
WHERE DATEDIFF(HH, StartTime, EndTime) > 12
