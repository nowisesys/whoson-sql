USE [WhosOn]
GO

/****** Object:  StoredProcedure [dbo].[GetUsageSummary]    Script Date: 12/07/2012 12:29:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
 * Description:
 * 
 *   Get usage summary as total number of logon hours. The summary 
 *   can be filtered on timespan (start <-> end), user, domain and 
 *   hostname. 
 * 
 *   The filtering is additive: More filter parameters -> more restrictions.
 *   Using no filter gives a summary of all logon sessions.
 *
 * Author: Anders Lövgren
 * Date:   2012-12-07
 */
CREATE PROCEDURE [dbo].[GetUsageSummary]
	@stime	DATETIME = NULL,		/* Start time */
	@etime	DATETIME = NULL,		/* End time */
	@user	NCHAR(20) = NULL,		/* Filter on user */
	@domain	NCHAR(16) = NULL,		/* Filter on domain */
	@host	NVARCHAR(50) = NULL		/* Filter on hostname */
AS
BEGIN
	SET NOCOUNT ON;

	/* Dynamic build query string */
	DECLARE @sqlquery NVARCHAR(1000)
	DECLARE @paramdef NVARCHAR(1000)
	DECLARE @criteria NVARCHAR(1000)
	
	SET @criteria = ''
	SET @paramdef = '
		@stime	DATETIME,
		@etime	DATETIME,
		@user	NCHAR(20),
		@domain	NCHAR(16),
		@host	NVARCHAR(50)'
	
	SELECT @sqlquery = '
		SELECT	SUM(CAST(DATEDIFF(SS, StartTime, EndTime) AS FLOAT))/3600 
		FROM	Logons'
	
	IF((@stime IS NOT NULL) AND (@etime IS NOT NULL))
		SELECT @criteria += '(StartTime BETWEEN @stime AND @etime)'	
	IF(@user IS NOT NULL)
		SELECT @criteria += ' AND Username = @user'
	IF(@domain IS NOT NULL)
		SELECT @criteria += ' AND Domain = @domain'
	IF(@host IS NOT NULL) 
		SELECT @criteria += ' AND Hostname = @host'
	
	/* 
	 * Strip leading 'AND' in criteria and prefix with WHERE if
	 * any parameters were passed. Note that CHARINDEX() don't
	 * count char index in string as zero-based.
	 */
	IF(CHARINDEX('AND', @criteria, 0) = 2)
		SELECT @criteria = SUBSTRING(@criteria, 5, LEN(@criteria) - 4)
	IF(LEN(@criteria) > 0)
		SELECT @sqlquery += ' WHERE ' + @criteria
	
	EXEC sp_executesql @sqlquery, @paramdef, @stime, @etime, @user, @domain, @host
END

GO

