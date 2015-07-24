use LCCHPTestImport
GO

-- daycare choices specified by LCCHP group
Insert into Daycare (DaycareName,DaycareDescription) values ('Daycare','Child attends daycare'),
('Preschool','Child attends preschool'),
('Morning Star','Child attends Morning Star'),
('Headstart','Child attends Headstart'),
('Other','Child attends some other form of childcare'),
('None','Child does not attend any form of childcare')



select * from Daycare