USE BridgePrepNewDB;
GO

SELECT 
    UserId,
    FullName,
    Email,
    PasswordHash,
    CreatedAt
FROM Users;


CREATE TABLE [dbo].[Scores] (
    [ScoreId]    INT      IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    [StudentId]  INT      NOT NULL REFERENCES [dbo].[Users]([UserId]),
    [QuizId]     INT      NOT NULL REFERENCES [dbo].[Quizzes]([QuizId]),
    [Score]      INT      NOT NULL,
    [TotalMarks] INT      NOT NULL,
    [TakenAt]    DATETIME DEFAULT (GETDATE()) NULL
);



IF OBJECT_ID('dbo.Scores', 'U') IS NOT NULL
    DROP TABLE dbo.Scores;
GO

CREATE TABLE [dbo].[Scores] (
    [ScoreId]    INT      IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    [StudentId]  INT      NOT NULL REFERENCES [dbo].[Users]([UserId]),
    [QuizId]     INT      NOT NULL REFERENCES [dbo].[Quizzes]([QuizId]),
    [Score]      INT      NOT NULL,
    [TotalMarks] INT      NOT NULL,
    [TakenAt]    DATETIME DEFAULT (GETDATE()) NULL
);
GO



SELECT * FROM Users;











USE BridgePrepNewDB;
GO

-- 1. Create Roles Table (if not existing)
IF OBJECT_ID('dbo.Roles', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Roles] (
        [RoleId]   INT          IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        [RoleName] NVARCHAR(50) NOT NULL
    );
    INSERT INTO dbo.Roles (RoleName) VALUES ('Admin'), ('Teacher'), ('Student');
END
GO

-- 2. Create Subjects Table
IF OBJECT_ID('dbo.Subjects', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Subjects] (
        [SubjectId]   INT            IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        [SubjectName] NVARCHAR(100) NOT NULL,
        [Description] NVARCHAR(255) NULL
    );

    INSERT INTO dbo.Subjects (SubjectName, Description) VALUES 
    ('English', 'English Language & Literature Module'),
    ('Mathematics', 'Algebra, Geometry, & Arithmetic Module'),
    ('Science', 'Physics, Chemistry, & Biology Module');
END
GO

-- 3. Create Materials Table
IF OBJECT_ID('dbo.Materials', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Materials] (
        [MaterialId] INT            IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        [Title]      NVARCHAR(150) NOT NULL,
        [SubjectId]  INT            NOT NULL REFERENCES [dbo].[Subjects]([SubjectId]) ON DELETE CASCADE
    );
END
GO

-- 4. Create Student Performance View for the Reports Feature
IF OBJECT_ID('dbo.StudentResults', 'V') IS NOT NULL
    DROP VIEW dbo.StudentResults;
GO

CREATE VIEW dbo.StudentResults AS
SELECT 
    s.ScoreId,
    u.FullName AS StudentName,
    q.QuizTitle,
    sub.SubjectName,
    s.Score,
    s.TotalMarks,
    s.TakenAt
FROM dbo.Scores s
INNER JOIN dbo.Users u ON s.StudentId = u.UserId
INNER JOIN dbo.Quizzes q ON s.QuizId = q.QuizId
INNER JOIN dbo.Subjects sub ON q.SubjectId = sub.SubjectId;
GO







USE BridgePrepNewDB;
GO

INSERT INTO Users (FullName, Email, PasswordHash, RoleId, CreatedAt)
VALUES ('System Admin', 'admin@gmail.com', 'admin123', 1, GETDATE());



USE BridgePrepNewDB;
SELECT u.UserId, u.FullName, u.Email, u.RoleId, r.RoleName 
FROM Users u 
JOIN Roles r ON u.RoleId = r.RoleId;





USE BridgePrepNewDB;
GO

-- Option A: If your PasswordHelper uses SHA256 (Most Common):
UPDATE Users 
SET PasswordHash = LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'admin123'), 2))
WHERE Email = 'admin@gmail.com';






-- 1. USERS TABLE (Handles Logins & Roles)
-- RoleId: 1 = Admin, 2 = Teacher, 3 = Student
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
    CREATE TABLE [dbo].[Users] (
        [UserId]   INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        [UserName] NVARCHAR(100) NOT NULL,
        [Email]    NVARCHAR(150) NOT NULL UNIQUE,
        [Password] NVARCHAR(255) NOT NULL,
        [RoleId]   INT NOT NULL DEFAULT (3), 
        [CreatedAt] DATETIME DEFAULT (GETDATE()) NULL
    );
END

-- 2. SUBJECTS TABLE (Course Categories)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Subjects')
BEGIN
    CREATE TABLE [dbo].[Subjects] (
        [SubjectId]   INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        [SubjectName] NVARCHAR(150) NOT NULL
    );
END

-- 3. LEARNING MATERIALS TABLE (Uploaded Resources)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LearningMaterials')
BEGIN
    CREATE TABLE [dbo].[LearningMaterials] (
        [MaterialId]  INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        [SubjectId]   INT NOT NULL,
        [Title]       NVARCHAR(255) NOT NULL,
        [ContentType] NVARCHAR(50) NOT NULL, -- e.g., PDF, Video, Article
        [ContentUrl]  NVARCHAR(500) NOT NULL,
        [UploadedBy]  INT NOT NULL,
        [UploadedAt]  DATETIME DEFAULT (GETDATE()) NULL,
        CONSTRAINT [FK_LearningMaterials_Subjects] FOREIGN KEY ([SubjectId]) REFERENCES [dbo].[Subjects] ([SubjectId]) ON DELETE CASCADE
    );
END

-- 4. QUIZZES TABLE (Quiz Metadata)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Quizzes')
BEGIN
    CREATE TABLE [dbo].[Quizzes] (
        [QuizId]     INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        [SubjectId]  INT NOT NULL,
        [TeacherId]  INT NOT NULL,
        [QuizTitle]  NVARCHAR(200) NOT NULL,
        [TotalMarks] INT NOT NULL DEFAULT (10),
        [CreatedAt]  DATETIME DEFAULT (GETDATE()) NULL,
        CONSTRAINT [FK_Quizzes_Subjects] FOREIGN KEY ([SubjectId]) REFERENCES [dbo].[Subjects] ([SubjectId]) ON DELETE CASCADE
    );
END

-- 5. QUESTIONS TABLE (Multiple Choice Questions)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Questions')
BEGIN
    CREATE TABLE [dbo].[Questions] (
        [QuestionId]    INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        [QuizId]        INT NOT NULL,
        [QuestionText]  NVARCHAR(MAX) NOT NULL,
        [OptionA]       NVARCHAR(255) NOT NULL,
        [OptionB]       NVARCHAR(255) NOT NULL,
        [OptionC]       NVARCHAR(255) NOT NULL,
        [OptionD]       NVARCHAR(255) NOT NULL,
        [CorrectOption] CHAR(1) NOT NULL, -- Stored as 'A', 'B', 'C', or 'D'
        CONSTRAINT [FK_Questions_Quizzes] FOREIGN KEY ([QuizId]) REFERENCES [dbo].[Quizzes] ([QuizId]) ON DELETE CASCADE
    );
END

-- 6. SCORES TABLE (Student Results & Grades)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Scores')
BEGIN
    CREATE TABLE [dbo].[Scores] (
        [ScoreId]    INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        [StudentId]  INT NOT NULL,
        [QuizId]     INT NOT NULL,
        [Score]      INT NOT NULL,
        [TotalMarks] INT NOT NULL,
        [TakenAt]    DATETIME DEFAULT (GETDATE()) NULL,
        CONSTRAINT [FK_Scores_Quizzes] FOREIGN KEY ([QuizId]) REFERENCES [dbo].[Quizzes] ([QuizId]) ON DELETE CASCADE
    );
END


USE BridgePrepNewDB; -- Replace with your actual database name
GO
SELECT * FROM Materials;

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT * FROM LearningMaterials;


USE BridgePrepNewDB;
GO
IF OBJECT_ID('dbo.Materials', 'U') IS NOT NULL
    DROP TABLE dbo.Materials;
GO


UPDATE LearningMaterials
SET ContentUrl = REPLACE(ContentUrl, '~/', '/')
WHERE ContentUrl LIKE '~/%';









USE BridgePrepNewDB;
GO

-- 1. Create or ensure Scores table exists
IF OBJECT_ID('dbo.Scores', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Scores] (
        [ScoreId]    INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        [StudentId]  INT NOT NULL REFERENCES [dbo].[Users]([UserId]),
        [QuizId]     INT NOT NULL REFERENCES [dbo].[Quizzes]([QuizId]) ON DELETE CASCADE,
        [Score]      INT NOT NULL,
        [TotalMarks] INT NOT NULL,
        [TakenAt]    DATETIME DEFAULT (GETDATE()) NULL
    );
END
GO

-- 2. Create StudentResults View for performance tracking
IF OBJECT_ID('dbo.StudentResults', 'V') IS NOT NULL
    DROP VIEW dbo.StudentResults;
GO

CREATE VIEW dbo.StudentResults AS
SELECT 
    s.ScoreId,
    s.StudentId,
    u.FullName AS StudentName,
    q.QuizTitle,
    sub.SubjectName,
    s.Score,
    s.TotalMarks,
    s.TakenAt
FROM dbo.Scores s
INNER JOIN dbo.Users u ON s.StudentId = u.UserId
INNER JOIN dbo.Quizzes q ON s.QuizId = q.QuizId
INNER JOIN dbo.Subjects sub ON q.SubjectId = sub.SubjectId;
GO





USE BridgePrepNewDB;
GO

UPDATE LearningMaterials
SET ContentUrl = REPLACE(ContentUrl, '~/', '')
WHERE ContentUrl LIKE '~/%';
GO





