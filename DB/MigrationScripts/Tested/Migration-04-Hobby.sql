USE LCCHPPublic
GO
SET NOCOUNT ON;
-- hobbies identified from child notes table
Insert into Hobby
(LeadExposure,Hobbyname,HobbyDescription) Values
(1, 'Auto repair',NULL),
(1, 'Plumbing',NULL),
(1, 'Torch work',NULL),
(1, 'Furniture crafts', 'strip and/or refinish furniture'),
(1, 'Stained glass', NULL),
(1, 'Reloading','reloading ammunition'),
(1, 'Remodeling', NULL),
(1, 'Paint', NULL),
(1, 'Battery Work', NULL),
(1, 'Solder electronic parts',NULL),
(1, 'Solder pipes',NULL),
(1, 'Ceramic pottery', NULL),
(1, 'Pottery', NULL),
(1, 'Paint - oil paints', NULL),
(1, 'Jewelry', 'make and/or repair metal jewelry'),
(1, 'Paint - cars', NULL),
(1, 'Electronics', NULL),
(0, 'Photography', NULL),
(1, 'Salvage metals',NULL),
(1, 'Welding', NULL)

select HobbyID,HobbyName,LeadExposure from Hobby