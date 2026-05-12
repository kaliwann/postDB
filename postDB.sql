/*
Created: 05.05.2026
Modified: 06.05.2026
Model: Microsoft SQL Server 2019
Database: MS SQL Server 2019
*/
USE master
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'postDB')
BEGIN
   ALTER DATABASE postDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
   DROP DATABASE postDB
END
GO

CREATE DATABASE postDB
GO

USE postDB
GO


-- Create tables section -------------------------------------------------

-- Table PostOffices

CREATE TABLE [PostOffices]
(
 [OfficeID] Int NOT NULL,
 [City] Nvarchar(100) NULL,
 [Address] Nvarchar(200) NULL,
 CONSTRAINT [PK_PostOffices] PRIMARY KEY ([OfficeID])
)
AS NODE
go

-- Table Parcels

CREATE TABLE [Parcels]
(
 [ParcelID] Int NOT NULL,
 [Weight] Decimal(10,2) NULL,
 [Type] Nvarchar(50) NULL,
 CONSTRAINT [PK_Parcels] PRIMARY KEY ([ParcelID])
)
AS NODE
go

-- Table Postmen

CREATE TABLE [Postmen]
(
 [PostmanID] Int NOT NULL,
 [FullName] Nvarchar(100) NOT NULL,
 CONSTRAINT [PK_Postmen] PRIMARY KEY ([PostmanID])
)
AS NODE
go

-- Table WorksIn

CREATE TABLE [WorksIn]
AS EDGE
go

-- Add connection constraints for table WorksIn

ALTER TABLE [WorksIn] ADD CONSTRAINT [EC_WorksIn] CONNECTION (
  [Postmen] TO [PostOffices])
go

-- Table StoredAt

CREATE TABLE [StoredAt]
(
 [ArrivalDate] Datetime NOT NULL
)
AS EDGE
go

-- Add connection constraints for table StoredAt

ALTER TABLE [StoredAt] ADD CONSTRAINT [EC_StoredAt] CONNECTION (
  [Parcels] TO [PostOffices])
go

-- Table Delivers

CREATE TABLE [Delivers]
(
 [DeliveryStatus] Nvarchar(50) NULL,
 [Priority] Int NULL
)
AS EDGE
go

-- Add connection constraints for table Delivers

ALTER TABLE [Delivers] ADD CONSTRAINT [EC_Delivers] CONNECTION (
  [Postmen] TO [Parcels])
go








INSERT INTO [PostOffices] ([OfficeID], [City], [Address]) VALUES
(1, N'Минск', N'пр. Независимости, 6'),
(2, N'Гомель', N'ул. Советская, 8'),
(3, N'Гродно', N'ул. Карла Маркса, 11'),
(4, N'Брест', N'пр. Машерова, 32'),
(5, N'Витебск', N'ул. Ленина, 2'),
(6, N'Могилев', N'ул. Первомайская, 28'),
(7, N'Барановичи', N'ул. Советская, 54'),
(8, N'Пинск', N'ул. Заслонова, 13'),
(9, N'Борисов', N'пр. Революции, 4'),
(10, N'Лида', N'ул. Кирова, 19');

INSERT INTO [Postmen] ([PostmanID], [FullName]) VALUES
(1, N'Иванов Иван Иванович'),
(2, N'Петров Петр Петрович'),
(3, N'Сидоров Алексей Николаевич'),
(4, N'Козлов Дмитрий Сергеевич'),
(5, N'Мороз Елена Викторовна'),
(6, N'Волк Марина Александровна'),
(7, N'Заяц Игорь Владимирович'),
(8, N'Лисица Ольга Павловна'),
(9, N'Медведь Артем Игоревич'),
(10, N'Соколов Денис Юрьевич'),
(11, N'Григорьев Григорий Григорьевич'),
(12, N'Павлов Павел Павлович'),
(13, N'Антонов Антон Антонович'),
(14, N'Степанов Степан Степанович'),
(15, N'Николаев Николай Николаевич');

INSERT INTO [Parcels] ([ParcelID], [Weight], [Type]) VALUES
(1, 1.50, N'Бандероль'),
(2, 5.20, N'Посылка'),
(3, 0.20, N'Письмо'),
(4, 12.00, N'Крупногабарит'),
(5, 2.10, N'Посылка'),
(6, 0.50, N'Бандероль'),
(7, 7.80, N'Посылка'),
(8, 0.10, N'Письмо'),
(9, 3.40, N'Посылка'),
(10, 15.00, N'Крупногабарит');

INSERT INTO [WorksIn] ($from_id, $to_id) VALUES
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 1), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 1)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 2), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 10)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 3), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 5)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 4), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 2)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 5), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 4)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 6), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 3)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 7), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 6)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 8), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 7)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 9), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 9)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 10), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 8)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 11), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 10)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 12), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 9)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 13), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 8)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 14), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 1)),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 15), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 7));

INSERT INTO [StoredAt] ($from_id, $to_id, [ArrivalDate]) VALUES
((SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 1), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 1), '2026-05-01 10:00'),
((SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 2), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 2), '2026-05-02 11:30'),
((SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 3), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 6), '2026-05-03 09:15'),
((SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 4), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 3), '2026-05-04 14:00'),
((SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 5), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 8), '2026-05-05 08:45'),
((SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 6), (SELECT $node_id FROM [PostOffices] WHERE [OfficeID] = 5), '2026-05-06 12:00');

INSERT INTO [Delivers] ($from_id, $to_id, [DeliveryStatus], [Priority]) VALUES
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 1), (SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 1), N'В пути', 1),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 1), (SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 2), N'Доставлено', 2),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 3), (SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 3), N'В пути', 3),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 4), (SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 4), N'Ожидание', 1),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 5), (SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 5), N'В пути', 2),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 5), (SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 6), N'В пути', 2),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 12), (SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 7), N'Ожидание', 1),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 5), (SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 8), N'Доставлено', 3),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 3), (SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 9), N'В пути', 2),
((SELECT $node_id FROM [Postmen] WHERE [PostmanID] = 15), (SELECT $node_id FROM [Parcels] WHERE [ParcelID] = 10), N'В пути', 1);



SELECT 
    P.FullName AS Postman, 
    Pr.Type AS ParcelType, 
    O.City, 
    O.Address
FROM Postmen P, Delivers D, Parcels Pr, StoredAt S, PostOffices O
WHERE MATCH(P-(D)->Pr-(S)->O);

SELECT P.FullName, Pr.ParcelID, O.City
FROM Postmen P, WorksIn W, PostOffices O, StoredAt S, Parcels Pr, Delivers D
WHERE MATCH(O<-(W)-P-(D)->Pr-(S)->O);

SELECT DISTINCT O.City, O.Address
FROM PostOffices O, WorksIn W, Postmen P, Delivers D, Parcels Pr
WHERE MATCH(O<-(W)-P-(D)->Pr)
AND Pr.Type = N'Бандероль';

SELECT P.FullName, Pr.Type, O.City
FROM Postmen P, Delivers D, Parcels Pr, StoredAt S, PostOffices O
WHERE MATCH(P-(D)->Pr-(S)->O)
AND D.Priority = 1;

SELECT DISTINCT P.FullName, O.City, D.DeliveryStatus
FROM Postmen P, WorksIn W, PostOffices O, Delivers D, Parcels Pr
WHERE MATCH(O<-(W)-P-(D)->Pr)
AND D.DeliveryStatus = N'В пути';

SELECT 
    P.FullName AS PostmanName,
    STRING_AGG(O.City, ' -> ') WITHIN GROUP (GRAPH PATH) AS PathToCity
FROM 
    Postmen AS P,
    Delivers FOR PATH AS d,
    Parcels FOR PATH AS Pr,
    StoredAt FOR PATH AS s,
    PostOffices FOR PATH AS O
WHERE MATCH(SHORTEST_PATH(P(-(d)->Pr-(s)->O){1,5}))
AND P.PostmanID = 1;

SELECT 
    P.FullName AS Postman,
    STRING_AGG(CAST(Pr.Type AS VARCHAR(MAX)), ' + ') WITHIN GROUP (GRAPH PATH) AS ParcelTypes,
    STRING_AGG(CAST(O.City AS VARCHAR(MAX)), ' -> ') WITHIN GROUP (GRAPH PATH) AS TargetCities
FROM 
    Postmen AS P,
    Delivers FOR PATH AS d,
    Parcels FOR PATH AS Pr,
    StoredAt FOR PATH AS s,
    PostOffices FOR PATH AS O
WHERE MATCH(SHORTEST_PATH(P(-(d)->Pr-(s)->O)+))
AND P.FullName LIKE N'Иванов%';