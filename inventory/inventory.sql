CREATE TABLE Data.Inventory(InventoryID INT NOT NULL IDENTITY,
  ItemID INT NOT NULL,
  ChangeDate DATETIME NOT NULL,
  ChangeQty INT NOT NULL,
  TotalQty INT NOT NULL,
  PreviousChangeDate DATETIME NULL,
  PreviousTotalQty INT NULL,
  CONSTRAINT PK_Inventory PRIMARY KEY(ItemID, ChangeDate),
  CONSTRAINT UNQ_Inventory UNIQUE(ItemID, ChangeDate, TotalQty),
  CONSTRAINT UNQ_Inventory_Previous_Columns 
     UNIQUE(ItemID, PreviousChangeDate, PreviousTotalQty),
  CONSTRAINT FK_Inventory_Self FOREIGN KEY(ItemID, PreviousChangeDate, PreviousTotalQty)
    REFERENCES Data.Inventory(ItemID, ChangeDate, TotalQty),
  CONSTRAINT CHK_Inventory_Valid_TotalQty CHECK(
         TotalQty >= 0 
     AND (TotalQty = COALESCE(PreviousTotalQty, 0) + ChangeQty)
  ),
  CONSTRAINT CHK_Inventory_Valid_Dates_Sequence CHECK(PreviousChangeDate < ChangeDate),
  CONSTRAINT CHK_Inventory_Valid_Previous_Columns CHECK(
        (PreviousChangeDate IS NULL AND PreviousTotalQty IS NULL)
     OR (PreviousChangeDate IS NOT NULL AND PreviousTotalQty IS NOT NULL)
  )
);

-- beginning of inventory for item 1
INSERT INTO Data.Inventory(ItemID,
  ChangeDate,
  ChangeQty,
  TotalQty,
  PreviousChangeDate,
  PreviousTotalQty)
VALUES(1, '20090101', 10, 10, NULL, NULL);

-- cannot begin the inventory for the second time for the same item 1
INSERT INTO Data.Inventory(ItemID,
  ChangeDate,
  ChangeQty,
  TotalQty,
  PreviousChangeDate,
  PreviousTotalQty)
VALUES(1, '20090102', 10, 10, NULL, NULL);


-- Msg 2627, Level 14, State 1, Line 10
-- 
-- Violation of UNIQUE KEY constraint 'UNQ_Inventory_Previous_Columns'. 
-- Cannot insert duplicate key in object 'Data.Inventory'.
-- 
-- The statement has been terminated.


-- add more
DECLARE @ChangeQty INT;
SET @ChangeQty = 5;

INSERT INTO Data.Inventory(ItemID,
  ChangeDate,
  ChangeQty,
  TotalQty,
  PreviousChangeDate,
  PreviousTotalQty)

SELECT TOP 1 ItemID, '20090103', @ChangeQty, TotalQty + @ChangeQty, ChangeDate, TotalQty
  FROM Data.Inventory
  WHERE ItemID = 1
  ORDER BY ChangeDate DESC;

SET @ChangeQty = 3;

INSERT INTO Data.Inventory(ItemID,
  ChangeDate,
  ChangeQty,
  TotalQty,
  PreviousChangeDate,
  PreviousTotalQty)

SELECT TOP 1 ItemID, '20090104', @ChangeQty, TotalQty + @ChangeQty, ChangeDate, TotalQty
  FROM Data.Inventory
  WHERE ItemID = 1
  ORDER BY ChangeDate DESC;

SET @ChangeQty = -4;

INSERT INTO Data.Inventory(ItemID,
  ChangeDate,
  ChangeQty,
  TotalQty,
  PreviousChangeDate,
  PreviousTotalQty)

SELECT TOP 1 ItemID, '20090105', @ChangeQty, TotalQty + @ChangeQty, ChangeDate, TotalQty
  FROM Data.Inventory
  WHERE ItemID = 1
  ORDER BY ChangeDate DESC;

-- try to violate chronological order
SET @ChangeQty = 5;

INSERT INTO Data.Inventory(ItemID,
  ChangeDate,
  ChangeQty,
  TotalQty,
  PreviousChangeDate,
  PreviousTotalQty)

SELECT TOP 1 ItemID, '20081231', @ChangeQty, TotalQty + @ChangeQty, ChangeDate, TotalQty
  FROM Data.Inventory
  WHERE ItemID = 1
  ORDER BY ChangeDate DESC;

-- Msg 547, Level 16, State 0, Line 4
-- 
-- The INSERT statement conflicted with the CHECK constraint 
-- "CHK_Inventory_Valid_Dates_Sequence". 
-- The conflict occurred in database "Test", table "Data.Inventory".

The statement has been terminated.

SELECT ChangeDate,
  ChangeQty,
  TotalQty,
  PreviousChangeDate,
  PreviousTotalQty
FROM Data.Inventory ORDER BY ChangeDate;

-- ChangeDate              ChangeQty   TotalQty    PreviousChangeDate      PreviousTotalQty
-- ----------------------- ----------- ----------- ----------------------- -----
-- 2009-01-01 00:00:00.000 10          10          NULL                    NULL
-- 2009-01-03 00:00:00.000 5           15          2009-01-01 00:00:00.000 10
-- 2009-01-04 00:00:00.000 3           18          2009-01-03 00:00:00.000 15
-- 2009-01-05 00:00:00.000 -4          14          2009-01-04 00:00:00.000 18


-- try to change a single row, all updates must fail
UPDATE Data.Inventory SET ChangeQty = ChangeQty + 2 WHERE InventoryID = 3;
UPDATE Data.Inventory SET TotalQty = TotalQty + 2 WHERE InventoryID = 3;

-- try to delete not the last row, all deletes must fail
DELETE FROM Data.Inventory WHERE InventoryID = 1;
DELETE FROM Data.Inventory WHERE InventoryID = 3;

-- the right way to update
DECLARE @IncreaseQty INT;

SET @IncreaseQty = 2;

UPDATE Data.Inventory 
SET 
     ChangeQty = ChangeQty 
   + CASE 
        WHEN ItemID = 1 AND ChangeDate = '20090103' 
        THEN @IncreaseQty 
        ELSE 0 
     END,
  TotalQty = TotalQty + @IncreaseQty,
  PreviousTotalQty = PreviousTotalQty + 
     CASE 
        WHEN ItemID = 1 AND ChangeDate = '20090103' 
        THEN 0 
        ELSE @IncreaseQty 
     END
WHERE ItemID = 1 AND ChangeDate >= '20090103';

SELECT ChangeDate,
  ChangeQty,
  TotalQty,
  PreviousChangeDate,
  PreviousTotalQty
FROM Data.Inventory ORDER BY ChangeDate;

-- ChangeDate              ChangeQty   TotalQty    PreviousChangeDate      PreviousTotalQty
-- ----------------------- ----------- ----------- ----------------------- ----------------
-- 2009-01-01 00:00:00.000 10          10          NULL                    NULL
-- 2009-01-03 00:00:00.000 7           17          2009-01-01 00:00:00.000 10
-- 2009-01-04 00:00:00.000 3           20          2009-01-03 00:00:00.000 17
-- 2009-01-05 00:00:00.000 -4          16          2009-01-04 00:00:00.000 20
