USE [master]
GO
/****** Object:  Database [WhosOn]    Script Date: 11/23/2011 02:19:01 ******/
CREATE DATABASE [WhosOn] ON  PRIMARY 
( NAME = N'WhosOn', FILENAME = N'D:\Database\MSSQL\2008R2\Data\WhosOn.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'WhosOn_log', FILENAME = N'D:\Database\MSSQL\2008R2\Data\WhosOn_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [WhosOn] SET COMPATIBILITY_LEVEL = 90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WhosOn].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WhosOn] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [WhosOn] SET ANSI_NULLS OFF
GO
ALTER DATABASE [WhosOn] SET ANSI_PADDING OFF
GO
ALTER DATABASE [WhosOn] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [WhosOn] SET ARITHABORT OFF
GO
ALTER DATABASE [WhosOn] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [WhosOn] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [WhosOn] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [WhosOn] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [WhosOn] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [WhosOn] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [WhosOn] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [WhosOn] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [WhosOn] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [WhosOn] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [WhosOn] SET  ENABLE_BROKER
GO
ALTER DATABASE [WhosOn] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [WhosOn] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [WhosOn] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [WhosOn] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [WhosOn] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [WhosOn] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [WhosOn] SET  READ_WRITE
GO
ALTER DATABASE [WhosOn] SET RECOVERY SIMPLE
GO
ALTER DATABASE [WhosOn] SET  MULTI_USER
GO
ALTER DATABASE [WhosOn] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [WhosOn] SET DB_CHAINING OFF
GO
USE [WhosOn]
GO
/****** Object:  User [ASPNET]    Script Date: 11/23/2011 02:19:01 ******/
CREATE USER [ASPNET] FOR LOGIN [BMC-ITWC001\ASPNET] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Logons]    Script Date: 11/23/2011 02:19:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Logons](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nchar](20) NOT NULL,
	[Domain] [nchar](16) NOT NULL,
	[HwAddress] [nchar](17) NULL,
	[IpAddress] [nvarchar](46) NOT NULL,
	[Hostname] [nvarchar](50) NULL,
	[Workstation] [varchar](50) NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
 CONSTRAINT [PK_Logons] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[CreateLogonEvent]    Script Date: 11/23/2011 02:19:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
 * Description:
 * 
 *   Inserts an logon event in the database. The caller should ensure that no 
 *   previous logon event exist with the same characteristics (from argument 
 *   list).
 *
 *   The ID of the newly inserted logon event is passed as an output parameter 
 *   in @event_id.
 *
 * Return: 
 *
 *   The last error code on failure and 0 if successful.
 * 
 * Author: Anders Lövgren
 * Date:   2011-10-22
 */
CREATE PROCEDURE [dbo].[CreateLogonEvent]
( 
	@username	VARCHAR(20),		/* Logon username */
	@domain		VARCHAR(10),		/* Logon domain */
	@hwaddr		NCHAR(17) = NULL,	/* MAC-address */
	@ipaddr		NVARCHAR(46),		/* IPv4 or IPv6 address */
	@hostname	NVARCHAR(50),		/* DNS hostname (FQHN) */
	@wksta		VARCHAR(50),		/* NetBIOS name */
	@event_id	INT	OUTPUT			/* The event ID */
)
AS

SET NOCOUNT ON;

BEGIN
	INSERT INTO Logons(Username, Domain, HwAddress, IpAddress, Hostname, Workstation, Starttime)
	VALUES(@username, @domain, @hwaddr, @ipaddr, @hostname, @wksta, CURRENT_TIMESTAMP);
	IF @@error <> 0 BEGIN
		RETURN @@error
	END
END

SET @event_id = SCOPE_IDENTITY()
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[FindLogonEvent]    Script Date: 11/23/2011 02:19:01 ******/
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
	@domain		VARCHAR(10),		/* Logon domain */
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
/****** Object:  StoredProcedure [dbo].[CloseLogonEvent]    Script Date: 11/23/2011 02:19:01 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteLogonEvent]    Script Date: 11/23/2011 02:19:01 ******/
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
/****** Object:  StoredProcedure [dbo].[GetLogonData]    Script Date: 11/23/2011 02:19:01 ******/
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
