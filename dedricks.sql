DROP DATABASE   IF EXISTS     dedricks;
CREATE DATABASE IF NOT EXISTS dedricks;

use dedricks;


CREATE TABLE Measurement (
	MeasID         tinyint(1)    ZEROFILL NOT NULL,
	Measurement    varchar(8)             NOT NULL,
   #Ea             boolean                NOT NULL,

	Primary Key(MeasID)
);

CREATE TABLE Manufacturer (
	ManufID        smallint(4)   ZEROFILL NOT NULL,
	Manufacturer   varchar(32)            NOT NULL,

	Primary Key(ManufID)
);

CREATE TABLE Category (
	CatID          tinyint(2)    ZEROFILL,
	Category       varchar(16)            NOT NULL,

    Primary Key(CatID)
);

CREATE TABLE Item (
    UPC            int           ZEROFILL,
	ItemCode       smallint(4)   ZEROFILL NOT NULL,
	InStock        smallint                   NULL DEFAULT    0,
	ManufID        smallint(4)   ZEROFILL     NULL,
    Description    varchar(64)            NOT NULL DEFAULT   '',
    Price          decimal(6,2)           NOT NULL DEFAULT    0,
    Weight         decimal(6,2)               NULL DEFAULT NULL,
    MeasID         tinyint(1)    ZEROFILL NOT NULL DEFAULT    1,
    EaYN           boolean                NOT NULL DEFAULT TRUE,
    -- PictureID      smallint(4)   ZEROFILL     NULL,

    Foreign Key (ManufID)   References Manufacturer(ManufID),
    Foreign Key (MeasID)    References Measurement(MeasID),
    -- Foreign Key (PictureID) References Picture(PictureID),
    Primary Key (ItemCode),
    Unique Index ItemCode(ManufID, Description, Weight, MeasID)
);

CREATE TABLE Seasonal_Item (
    ItemCode       smallint(4)   ZEROFILL NOT NULL,
    StartDate      date                   NOT NULL,
    EndDate        date                   NOT NULL,

    Foreign Key(ItemCode)  References Item(ItemCode),
    Primary Key(ItemCode)
);

CREATE TABLE Item_Category (
	ItemCode      smallint(4)    ZEROFILL NOT NULL,
	CatID         tinyint(2)     ZEROFILL NOT NULL,
	
	Foreign Key(ItemCode)   References Item(ItemCode), 
	Foreign Key(CatID)      References Category(CatID),
	Primary Key(ItemCode, CatID)
);

-------------------------------------Zachs tables Below
CREATE TABLE Zip(
	Zip			varchar(5)		NOT NULL,
	City		varchar(20)		NULL,
	State		varchar(20)		NULL,

	Primary Key(Zip)
);


CREATE TABLE AddressBook(
	InfoID		smallint(10)	AUTO_INCREMENT,
	Email		varchar(30)		NOT NULL,
	Password 	varchar(255)	NOT NULL,
	FName		varchar(23)		NOT NULL,
	LName		varchar(23)		NULL,
	Phone		varchar(10)		NOT NULL,

	Primary Key(InfoID)
);


CREATE TABLE AddressBook_Optional(
	InfoID		smallint(10)	NOT NULL,
	Addy1		varchar(25)		NOT NULL,
	Addy2		varchar(25)		NULL,
	Zip			varchar(5)		NOT NULL,

	Primary Key(InfoID),

	Foreign Key(InfoID)		References AddressBook(InfoID),
	Foreign Key(Zip)		References Zip(Zip)
);


CREATE TABLE Job_Title(
	JobID		smallint(5)		NOT NULL,
	JobTitle 	varchar(20)		NOT NULL,
	PrivLvl		smallint(5)		NOT NULL,

	Primary Key(JobID)
);


CREATE TABLE Employee(
	EmpID		smallint(10)	NOT NULL,
	InfoID		smallint(10)	NOT NULL,
	JobID		smallint(5)		NOT NULL,

	Primary Key(EmpID),

	Foreign Key(InfoID)		References AddressBook(InfoID),
	Foreign Key(JobID)		References Job_Title(JobID)
);


CREATE TABLE Salary_Wage(
	EmpID		smallint(10)	NOT NULL,
	StartDate	date 			NOT NULL,
	EndDate		date 			NULL,
	WageYN      boolean 		NOT NULL,
	Rate		decimal(13,2)	NOT NULL,

	Primary Key(EmpID, StartDate),

	Foreign Key(EmpID)		References Employee(EmpID)
);


CREATE TABLE Hours_Log(
	EmpID			smallint(10)	NOT NULL,
	StartDateTime	datetime  		NOT NULL,
	EndDateTime		datetime 		NULL,

	Primary Key(EmpID, StartDateTime),

	Foreign Key(EmpID)		References Employee(EmpID)
);
-----------------------------------------------------------------Josh
CREATE TABLE Supplier
(
	SupID 			int				Primary Key AUTO_INCREMENT,
	InfoID			smallint(10) 	NOT NULL,
	AmntPurchased   int 			NOT NULL,

	Foreign Key (InfoID) 	References AddressBook(InfoID)
);

---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Supply_Order
(
	SupOrderID 		int				Primary Key AUTO_INCREMENT,
	SupID			int 			NOT NULL,
	DateOrdered     datetime		NOT NULL,
	TotalCost		decimal(13,2)	NOT NULL,

	Foreign Key (SupID) 	References Supplier(SupID)
);

---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Supplied_Item
(
	SupOrderID 		int				         NOT NULL,
	ItemCode 		smallint(4) 	ZEROFILL NOT NULL,
	DateReceived    datetime                     NULL, 
	DateSellBy		datetime 		             NULL,
	CostPerAmt		decimal(13,2)	         NOT NULL,
	AmtSupplied 	int 			         NOT NULL,
	AmtWasted		int 			         NOT NULL,
	
	Primary Key(SupOrderID, ItemCode),
	Foreign Key (SupOrderID) 	References Supply_Order(SupOrderID),
	Foreign Key (ItemCode) 		References Item(ItemCode)
);

---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Customer
(
	CustID 			int				Primary Key AUTO_INCREMENT,
	InfoID			smallint(10) 			NOT NULL,

	Foreign Key (InfoID) 	References AddressBook(InfoID)
);

----------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Cart
(
	CartID 			int				Primary Key AUTO_INCREMENT
	
);

----------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Customer_Order
(
	CartID 			int				Primary Key AUTO_INCREMENT,
	CustID			int 			NOT NULL DEFAULT 1,
	EmpID 			smallint 		NOT NULL DEFAULT 1,
	DateCustOrder   datetime 		NOT NULL,
	Subtotal		decimal(13,2)	NOT NULL,

	Foreign Key (CartID) 	References Cart(CartID),
	Foreign Key (CustID) 	References Customer(CustID),
	Foreign Key (EmpID) 	References Employee(EmpID)
);

-----------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Cart_Item
(
	CartID 			int				         NOT NULL,
	ItemCode 		smallint(4)     ZEROFILL NOT NULL,
	AmtToSell		smallint		         NOT NULL,
	MeasQuantity    decimal(13,2)	         DEFAULT 1,
	
	Foreign Key (CartID) 	References Cart(CartID),
	Foreign Key (ItemCode) 	References Item(ItemCode),
	Primary Key	(CartID, ItemCode, MeasQuantity)

);

#INSERT INTO Picture(PictureID, Picture) VALUES (00000, LOAD_FILE('C:/xampp/mysql/data/dedricks/kelifsm.png'));

INSERT INTO Measurement(MeasID, Measurement) VALUES (0, 'ea'     );
INSERT INTO Measurement(MeasID, Measurement) VALUES (1, 'lb.'    );
INSERT INTO Measurement(MeasID, Measurement) VALUES (2, 'oz.'    );
INSERT INTO Measurement(MeasID, Measurement) VALUES (3, 'fl. oz.');
INSERT INTO Measurement(MeasID, Measurement) VALUES (4, 'ml'     );
INSERT INTO Measurement(MeasID, Measurement) VALUES (5, 'L'      );
INSERT INTO Measurement(MeasID, Measurement) VALUES (6, 'pt'     );
INSERT INTO Measurement(MeasID, Measurement) VALUES (7, 'qt'     );
INSERT INTO Measurement(MeasID, Measurement) VALUES (8, 'gal'    );
INSERT INTO Measurement(MeasID, Measurement) VALUES (9, ''       );

INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (00, 'Home Blend'                  );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (01, 'Finger Lakes'                );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (02, 'Dutch Valley'                );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (03, 'Bob\'s Red Mill'             );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (04, 'Gatherer\'s'                 );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (05, 'Nutty & Fruity'              );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (06, 'Harold Import Co.'           );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (07, 'Wheat Montana'               );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (08, 'Primitives by Kathy'         );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (09, 'Made in USA'                 );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (10, 'Darice Inc.'                 );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (11, 'Audrey\'s'                   );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (12, 'Golden Barrel'               );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (13, 'Wholesome'                   );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (14, 'Bragg'                       );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (15, 'Junket'                      );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (16, 'Lawrence Foods'              );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (17, 'Butlers'                     );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (18, 'Andes'                       );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (19, 'Superior Touch'              );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (20, 'Mayor Potencial'             );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (21, 'Ye Olde Goat Cart'           );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (22, 'Southeastern'                );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (23, 'Mrs. Millers'                );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (24, 'Sommers'                     );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (25, 'Trinity Valley'              );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (26, 'Boylan'                      );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (27, 'Beak & Skiff Apple Orchards' );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (28, '1000 Island\'s'              );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (29, 'Simply Supreme'              );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (30, 'Downey\'s'                   );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (31, 'Cabot'                       );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (32, 'Edwards'                     );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (33, 'Cooper Hill Maple'           );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (34, 'A & L Farm Market'           );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (35, 'Dare'                        );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (36, 'Boghosian'                   );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (37, 'Zimmerman\'s'                );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (38, 'Jake & Amos'                 );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (39, 'Olivari'                     );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (40, 'Miss Linda\'s Baked Goods'   );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (41, 'Wild Garden'                 );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (42, 'Unique'                      );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (43, 'Blue Diamond'                );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (44, 'Gillium Candy Company'       );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (45, 'Tropical Green Organics'     );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (46, 'New Hope Mills'              );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (47, 'Crunchmaster'                );
INSERT INTO Manufacturer(ManufID, Manufacturer) VALUES (48, 'Argueta\'s'                  );

--INSERT INTO Category(CatID, Category) VALUES (00, '0.Admin'        );
INSERT INTO Category(CatID, Category) VALUES (01, 'Baking'         );
INSERT INTO Category(CatID, Category) VALUES (02, 'Beans'          );
INSERT INTO Category(CatID, Category) VALUES (03, 'Beverage'       );
INSERT INTO Category(CatID, Category) VALUES (04, 'Candles'        );
INSERT INTO Category(CatID, Category) VALUES (05, 'Cereals'        );
INSERT INTO Category(CatID, Category) VALUES (06, 'Coffee/Tea'     );
INSERT INTO Category(CatID, Category) VALUES (07, 'Condiments'     );
INSERT INTO Category(CatID, Category) VALUES (08, 'Dairy'          );
INSERT INTO Category(CatID, Category) VALUES (09, 'General'        );
INSERT INTO Category(CatID, Category) VALUES (10, 'Meat'           );
INSERT INTO Category(CatID, Category) VALUES (11, 'Mix'            );
INSERT INTO Category(CatID, Category) VALUES (12, 'Non-Perishable' );
INSERT INTO Category(CatID, Category) VALUES (13, 'Nuts/Seeds'     );
INSERT INTO Category(CatID, Category) VALUES (14, 'Oil/Vinegar'    );
INSERT INTO Category(CatID, Category) VALUES (15, 'Organic'        );
INSERT INTO Category(CatID, Category) VALUES (16, 'Pasta/Noodles'  );
INSERT INTO Category(CatID, Category) VALUES (17, 'Produce'        );
INSERT INTO Category(CatID, Category) VALUES (18, 'Snack'          );
INSERT INTO Category(CatID, Category) VALUES (19, 'Soap'           );
INSERT INTO Category(CatID, Category) VALUES (20, 'Special'        );
INSERT INTO Category(CatID, Category) VALUES (21, 'Spice/Herbs'    );
INSERT INTO Category(CatID, Category) VALUES (22, 'Sweets'         );
                                                                                                   # upc         code       qty   description                                                             price  weight meas manuf  ea?
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (1,              1,       0, 'Chai Tea',                                                                4.23,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (2,              2,       0, 'Hazelnut Cappuccino',                                                     3.72,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (3,              3,       0, 'Cinnamon Vanilla Nut Cappuccino',                                         5.58,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (4,              4,       0, 'Chocolate Raspberry Cappuccino',                                          5.58,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (5,              5,       0, 'French Vanilla Cappuccino',                                               3.72,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (6,              6,       0, 'Swiss Mocha Cappuccino',                                                  3.72,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (7,              7,       0, 'Dark Hot Chocolate Mix',                                                  4.47,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (8,              8,       0, 'Jamaican Me Crazy (Ground)',                                               8.0,     1,  0,  01,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (9,              9,       0, 'Dark Guatemala (Ground)',                                                  8.0,     1,  0,  01,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (10,             10,      0, 'Guatemala Juan Anna Toliman (Ground)',                                     8.0,     1,  0,  01,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (11,             11,      0, 'Witches Brew (Ground)',                                                    8.0,     1,  0,  01,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (12,             12,      0, 'Nutty Buddy (Ground)',                                                     8.0,     1,  0,  01,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (13,             13,      0, 'Skaneateles Blend (Ground)',                                               8.0,     1,  0,  01,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (14,             14,      0, 'Canandaigua Blend (Ground)',                                               8.0,     1,  0,  01,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (15,             15,      0, 'Chocolate Raspberry (Whole Bean)',                                         8.0,     1,  0,  01,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (16,             16,      0, 'Jamaican Me Crazy (Whole Bean)',                                           8.0,     1,  0,  01,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (17,             17,      0, 'Dark Guatemala (Whole Bean)',                                              8.0,     1,  0,  01, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (18,             18,      0, 'Skaneateles Blend (Whole Bean)',                                           8.0,     1,  0,  01, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (19,             19,      0, 'Canandaigua Blend (Whole Bean)',                                           8.0,     1,  0,  01, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (20,             20,      0, 'Finger Lakes Decaf (Ground)',                                              8.0,     1,  0,  01, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (21,             21,      0, 'Nutty Buddy (Whole Bean)',                                                 6.0,     1,  0,  01, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (22,             22,      0, 'Witches Brew (Whole Bean)',                                                8.0,     1,  0,  01,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (23,             23,      0, 'Yogurt Coated Raisins',                                                   3.85,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (24,             24,      0, 'Yogurt Coated Almonds',                                                   5.96,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (25,             25,      0, 'Currants with Oil',                                                       2.91,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (26,             26,      0, 'Black Corinthian Currants',                                               2.26,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (27,             27,      0, 'Natural Wild Blueberry Oatmeal',                                          4.12,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (28,             28,      0, 'Spearmint Leaves',                                                        1.99,  15.0,  2,  02, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (29,             29,      0, 'Mini Peppermint Puffs',                                                   5.49,  15.0,  2,  02, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (30,             30,      0, 'Natural Cinnamon Apple Oatmeal',                                          4.08,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (31,             31,      0, 'White Pepper Ground',                                                    30.16,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (32,             32,      0, 'Wintergreen Lozenges',                                                    1.99,  12.0,  2,  02, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (33,             33,      0, 'English Breakfast Bulk Tea',                                              18.0,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (34,             34,      0, 'Raspberry Bulk Tea',                                                     20.09,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (35,             35,      0, 'Chamomile Bulk Tea',                                                     18.26,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (36,             36,      0, 'Christmas Tree Drizzle Pretzel',                                          4.44,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (37,             37,      0, 'Roasted & Salted Soybeans',                                               5.87,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (38,             38,      0, 'Black Licorice Wheels',                                                    4.2,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (39,             39,      0, 'Gluten Free Oatmeal Blueberry and Hazelnut',                              2.49,   2.5,  2,  03,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (40,             40,      0, 'Gourmet Granola',                                                         7.39,   9.0,  2,  04,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (41,             41,      0, 'Sliced Banana',                                                           4.79,   7.0,  2,  05,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (42,             42,      0, 'Mesh Wonder Ball',                                                        3.99,     1,  0,  06,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (43,             43,      0, 'Coconut Oolong Bulk Tea',                                                 31.0,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (44,             44,      0, 'Peppermint Bulk Tea',                                                     18.0,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (45,             45,      0, 'Hard Red Spring Wheat',                                                   4.72,   5.0,  1,  07,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (46,             46,      0, 'Magnetic List Notepad',                                                   2.99,     1,  1,  08,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (47,             47,      0, 'Magnetic Pad and Pencil',                                                 5.49,     1,  1,  09,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (48,             48,      0, 'Small Notebook Set',                                                      3.99,     1,  1,  08,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (49,             49,      0, 'Canvas Notebook',                                                        12.49,     1,  1,  08,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (50,             50,      0, 'Memo Pad',                                                                2.99,     1,  1,  10,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (51,             51,      0, '24in Hanging Sign',                                                      15.99,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (52,             52,      0, 'Family',                                                                  3.99,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (53,             53,      0, 'Box Sign',                                                               12.99,     1,  1,  08,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (54,             54,      0, 'Heart Shaped Matthew 5:14 Sign',                                          9.99,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (55,             55,      0, 'Stick Pencil',                                                            1.99,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (56,             56,      0, 'Cloth with Writing',                                                      5.99,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (57,             57,      0, 'Farm Fresh Vintage Tray',                                                26.99,     1,  1,  11,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (58,             58,      0, 'Message Blocks',                                                          5.59,     1,  1,  11, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (59,             59,      0, 'Unsulfured Blackstrap Molasses',                                         10.64,     1,  8,  12, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (60,             60,      0, 'Unsulfured Blackstrap Molasses',                                          4.99,     1,  7,  12,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (61,             61,      0, 'Organic Blue Agave',                                                      6.32,     1,  0,  13, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (62,             62,      0, 'Organic Raw Blue Agave',                                                  6.32,     1,  0,  13, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (63,             63,      0, 'Unfiltered Apple Cider Vinegar',                                          4.05,     1,  0,  14, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (64,             64,      0, 'Xanthan Gum',                                                             20.6,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (65,             65,      0, 'Dutch Jell? Natural Pectin Mix',                                          6.92,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (66,             66,      0, 'Danish Dessert',                                                          1.89,     1,  0,  15, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (67,             67,      0, 'Lemon Gelatin',                                                           3.46,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (68,             68,      0, 'Raspberry Gelatin',                                                       3.46,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (69,             69,      0, 'Natural Unflavored Gelatin',                                             12.65,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (70,             70,      0, 'Strawberry EZ Squeeze Filling',                                           4.75,     1,  0,  16,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (71,             71,      0, 'Bavarian Cream',                                                          4.75,     1,  0,  02,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (72,             72,      0, 'Gourmet Semi-Sweet Chocolate Drops',                                      3.75,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (73,             73,      0, 'Food Colors',                                                             2.89,     1,  0,  17, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (74,             74,      0, 'Artificial Coconut Flavor',                                                3.0,     1,  0,  17, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (75,             75,      0, 'Double Strength Clear imitation Vanilla',                                 4.65,     1,  0,  17, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (76,             76,      0, 'Pure Vanilla Extract',                                                   33.94,     1,  0,  17, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (77,             77,      0, 'Raspberry EZ Squeeze Filling',                                            4.75,     1,  0,  16, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (78,             78,      0, 'Apple EZ Squeeze Filling',                                                 4.0,     1,  0,  16, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (79,             79,      0, 'White Diamond Crystalz',                                                  7.02,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (80,             80,      0, 'Silver Crystalz',                                                         7.02,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (81,             81,      0, 'Emerald Green Crystalz',                                                  7.02,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (82,             82,      0, 'Gold Crystalz',                                                           7.02,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (83,             83,      0, 'Sapphire Blue Crystalz',                                                  7.02,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (84,             84,      0, 'Ruby Red Crystalz',                                                       7.02,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (85,             85,      0, 'Chocolate Sprinkles',                                                     5.25,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (86,             86,      0, 'Alum Powder(Food Grade)',                                                 2.96,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (87,             87,      0, 'Granulated Lemon Citrus Peel',                                            24.0,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (88,             88,      0, 'Crème De Menthe Baking Chips',                                            4.39,     1,  0,  18, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (89,             89,      0, 'Natural Cocoa Powder 10/12',                                              4.61,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (90,             90,      0, 'Black Cocoa Powder 10/12',                                                4.12,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (91,             91,      0, 'Dutch Cocoa Powder 10/12',                                                5.72,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (92,             92,      0, 'Light Green Sprinkles',                                                   4.39,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (93,             93,      0, 'Gingerbread Men Shapes',                                                  8.42,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (94,             94,      0, 'Pink Sanding Sugar',                                                      5.36,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (95,             95,      0, 'Pastel Yellow Sanding Sugar',                                             5.08,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (96,             96,      0, 'Red Sanding Sugar',                                                       5.33,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (97,             97,      0, 'Green Gourmet Sugar',                                                     5.52,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (98,             98,      0, 'Granulated Orange Citrus Peel',                                          11.94,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (99,             99,      0, 'Couscous with Chives and Saffron',                                        4.64,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (100,            100,     0, 'Organic Gluten Free Tri-Color Quinoa',                                    7.44,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (101,            101,     0, 'Quinoa',                                                                  3.95,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (102,            102,     0, 'Couscous(Whole Wheat)',                                                   2.06,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (103,            103,     0, 'Medium Couscous',                                                          1.9,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (104,            104,     0, 'Big Star Decoration',                                                    15.99,     1,  0,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (105,            105,     0, 'Long Grain Brown Rice 4%',                                                 1.2,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (106,            106,     0, 'Black Thai Rice(Purple Sticky)',                                          5.92,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (107,            107,     0, 'Red Rice',                                                                3.75,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (108,            108,     0, 'Brown Basmati Rice',                                                      4.53,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (109,            109,     0, 'Natural Northern Wild Rice',                                             14.14,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (110,            110,     0, 'Non GMO Natural White Jasmine Rice',                                       1.7,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (111,            111,     0, 'Ham Base',                                                                5.49,     1,  0,  19, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (112,            112,     0, 'Medium Grain White Rice',                                                 1.11,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (113,            113,     0, 'Long Grain White Rice 4%',                                                0.94,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (114,            114,     0, 'Roasted Beef Base',                                                       5.49,     1,  0,  19,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (115,            115,     0, 'Roasted Chicken Base',                                                    5.49,     1,  0,  19,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (116,            116,     0, 'Seasoned Vegetable Base',                                                 5.49,     1,  0,  19,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (117,            117,     0, 'Chicken Bouillon Cubes',                                                 10.74,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (118,            118,     0, 'Beef Bouillion Cubes',                                                   10.74,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (119,            119,     0, 'Vegetable Bouillon Cubes',                                               10.74,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (120,            120,     0, 'Lufa',                                                                    4.99,     1,  0,  20,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (121,            121,     0, 'GrapeFruit Candle',                                                       21.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (122,            122,     0, 'Coasters',                                                                8.99,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (123,            123,     0, 'Reduced Sodium Chicken Broth Mix',                                        5.46,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (124,            124,     0, 'Greeting Card',                                                           6.49,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (125,            125,     0, 'Salted Caramel Candle Medium-Small',                                       8.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (126,            126,     0, 'Mango Peach Preserves Medium',                                            14.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (127,            127,     0, 'Salted Caramel Candle Small',                                              6.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (128,            128,     0, 'Mango Peach Preserves Large',                                             21.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (129,            129,     0, 'Hazelnut Candle Medium-Small',                                             8.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (130,            130,     0, 'Beard Oil Unscented',                                                     15.0,     1,  0,  21,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (131,            131,     0, 'Chapstick orange',                                                         2.5,     1,  0,  21,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (132,            132,     0, 'Hazelnut Candle Medium',                                                  14.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (133,            133,     0, 'Harvest Candle Medium-Small',                                              8.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (134,            134,     0, 'Harvest Candle Small',                                                     6.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (135,            135,     0, 'Hazelnut Candle Large',                                                   21.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (136,            136,     0, 'Gingerbread Candle Small',                                                 6.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (137,            137,     0, 'Gingerbread Candle Large',                                                21.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (138,            138,     0, 'Farmers Market Candle Small',                                              6.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (139,            139,     0, 'Farmers Market Candle Medium-Small',                                       8.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (140,            140,     0, 'Gingerbread Candle Medium-Small',                                          8.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (141,            141,     0, 'Gingerbread Candle Medium',                                               14.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (142,            142,     0, 'Farmers Market Candle Medium',                                            14.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (143,            143,     0, 'Farmers Market Candle Large',                                             21.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (144,            144,     0, 'Farmhouse Cider Candle Medium-Small',                                      8.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (145,            145,     0, 'Cranberry Chutney Candle Small',                                           6.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (146,            146,     0, 'Cranberry Chutney Candle Medium',                                         14.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (147,            147,     0, 'Farmhouse Cider Candle Large',                                            21.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (148,            148,     0, 'Cinnamon and Spice Candle Medium-Small',                                   8.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (149,            149,     0, 'Cinnamon and Spice Candle Medium',                                        14.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (150,            150,     0, 'Cinnamon and Spice Candle Large',                                         21.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (151,            151,     0, 'Buttery Maple Syrup Medium',                                              14.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (152,            152,     0, 'Buttery Maple Syrup Medium-Small',                                         8.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (153,            153,     0, 'Buttery Maple Syrup Large',                                               21.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (154,            154,     0, 'Roast Beef Gravy Mix',                                                    1.72,     1,  0,  22,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (155,            155,     0, 'Country Gravy Mix',                                                       1.72,     1,  0,  22,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (156,            156,     0, 'Roast Turkey Gravy Mix',                                                  1.64,     1,  0,  22,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (157,            157,     0, 'Roast Chicken Gravy Mix',                                                 1.75,     1,  0,  22,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (158,            158,     0, 'Cranberry Chutney Candle Large',                                          21.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (159,            159,     0, 'Buttered Maple Espresso Candle Large',                                    21.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (160,            160,     0, 'Buttered Maple Espresso Candle Medium',                                   14.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (161,            161,     0, 'Blueberry Cobbler Candle Small',                                           6.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (162,            162,     0, 'Blueberry Cobbler Candle Medium-Small',                                    8.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (163,            163,     0, 'Blueberry Cobbler Candle Large',                                          21.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (164,            164,     0, 'O\' Christmas Tree Candle Small',                                          6.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (165,            165,     0, 'O\' Christmas Tree Candle Medium',                                        14.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (166,            166,     0, 'Lantern Decorative',                                                     19.99,     1,  0,  11,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (167,            167,     0, 'Kiss me Goodnight Sign',                                                 10.49,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (168,            168,     0, 'Hatch America',                                                           25.0,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (169,            169,     0, 'Lemon-Pepper Noodles',                                                    3.25,     1,  0,  23,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (170,            170,     0, '16" Spray-Dk must/Autumn/Brown',                                          2.99,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (171,            171,     0, 'Spinach Noodles',                                                         3.25,     1,  0,  23,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (172,            172,     0, 'Pesto Noodles',                                                           3.25,     1,  0,  23,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (173,            173,     0, 'Tomato-Basil Noodles',                                                    3.25,     1,  0,  23,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (174,            174,     0, 'Broccoli-Carrot Noodles',                                                 3.23,     1,  0,  23,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (175,            175,     0, 'Artichoke-Spinach Noodles',                                               3.25,     1,  0,  23,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (176,            176,     0, 'Homestyle Egg Noodles',                                                   5.65,     1,  0,  24, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (177,            177,     0, 'Old Fashioned Kluski Noodles',                                            3.14,     1,  0,  23,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (178,            178,     0, 'Old Fashioned Angel Hair Noodles',                                        3.25,     1,  0,  23,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (179,            179,     0, 'Porcini Mushroom Egg Noodles',                                            5.65,     1,  0,  24,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (180,            180,     0, 'Egg White Wide Noodles',                                                  3.14,     1,  0,  23,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (181,            181,     0, 'Old Fashiond Wide Noodles',                                               3.14,     1,  0,  23,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (182,            182,     0, 'Medium Egg Noodles',                                                      2.27,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (183,            183,     0, 'Lemongrass Soap Container',                                                7.5,     1,  0,  21,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (184,            184,     0, 'Lavender Soap Container',                                                  7.5,     1,  0,  21,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (185,            185,     0, 'Rosemary and Peppermint Soap Container',                                   7.5,     1,  0,  21,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (186,            186,     0, 'Fresh Orange Soap Bar',                                                    7.5,     1,  0,  21,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (187,            187,     0, 'Patchouli Soap Bar',                                                       7.5,     1,  0,  21,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (188,            188,     0, 'Eucalyuptus Soap Bar',                                                     7.5,     1,  0,  21,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (189,            189,     0, 'Cucumber Melon Soap Bar',                                                  7.5,     1,  0,  21,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (190,            190,     0, 'Lemongrass Soap Bar',                                                      7.5,     1,  0,  21, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (191,            191,     0, 'Billy Goats Gruff Soap Bar',                                               8.0,     1,  0,  21, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (192,            192,     0, 'Lavender Soap Bar',                                                        7.5,     1,  0,  21, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (193,            193,     0, 'Patriotic Wildberry Soap Bar',                                             7.5,     1,  0,  21, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (194,            194,     0, 'Tea Tree Soap Bar',                                                        7.5,     1,  0,  21, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (195,            195,     0, 'RoseMary and Peppermint Soap Bar',                                         7.5,     1,  0,  21, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (196,            196,     0, 'Black Chia Seeds',                                                        7.82,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (197,            197,     0, 'Chili Powder',                                                           11.72,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (198,            198,     0, 'Chive Rings',                                                              1.0,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (199,            199,     0, 'Cilantro',                                                               18.33,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (200,            200,     0, 'Ceylon Ground Cinnamon',                                                 33.31,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (201,            201,     0, 'Ground Cinnamon 1% Volatile Oil',                                         9.22,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (202,            202,     0, 'Whole Cloves',                                                           23.91,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (203,            203,     0, 'Ground Cloves',                                                          27.38,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (204,            204,     0, 'Ground Allspice',                                                         13.5,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (205,            205,     0, 'Allspice Whole',                                                         14.07,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (206,            206,     0, 'Anise Seeds',                                                            12.47,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (207,            207,     0, 'Basil Leaves',                                                            22.2,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (208,            208,     0, 'Caraway Seeds Whole',                                                     7.72,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (209,            209,     0, 'Celery Flakes',                                                          21.28,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (210,            210,     0, 'Whole Celery Seeds',                                                      4.05,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (211,            211,     0, 'Celery Salt',                                                             4.94,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (212,            212,     0, 'Ground Nutmeg',                                                          26.17,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (213,            213,     0, 'Natural Herbes De Provence',                                             13.87,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (214,            214,     0, 'Italian Seasoning',                                                       7.92,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (215,            215,     0, 'Marjoram Leaves',                                                         1.25,     1,  0,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (216,            216,     0, 'Ground Mustard Seeds',                                                    6.93,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (217,            217,     0, 'Mustard Seeds #1',                                                        7.04,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (218,            218,     0, 'Garlic Powder',                                                          11.51,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (219,            219,     0, 'Roasted Granulated Garlic',                                              25.55,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (220,            220,     0, 'Garlic Salt',                                                             7.18,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (221,            221,     0, 'Ground Ginger',                                                            9.5,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (222,            222,     0, 'Ground Cumin',                                                            9.05,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (223,            223,     0, 'Natural Curry Powder',                                                    8.29,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (224,            224,     0, 'Dill Weed',                                                              25.34,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (225,            225,     0, 'Whole Fennel Seed',                                                       8.18,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (226,            226,     0, 'Whole Cortander',                                                         5.54,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (227,            227,     0, 'Ground Cortander',                                                        6.78,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (228,            228,     0, '3-inch Cinnamon Sticks',                                                 12.91,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (229,            229,     0, 'Whole Nutmeg',                                                           29.33,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (230,            230,     0, 'Minced Onion',                                                             9.7,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (231,            231,     0, 'Onion Salt, No MSG Added',                                                6.04,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (232,            232,     0, 'Oregano Ground',                                                          9.99,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (233,            233,     0, 'Hungarian Paprika',                                                      10.34,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (234,            234,     0, 'Smoked Paprika',                                                          12.0,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (235,            235,     0, 'Medium Grind Black Pepper',                                              19.38,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (236,            236,     0, 'Ground Red Pepper',                                                       8.01,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (237,            237,     0, 'Crushed Red Pepper ',                                                     7.67,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (238,            238,     0, 'Whole Black Peppercorns',                                                12.58,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (239,            239,     0, 'Mixed Peppercorns',                                                      39.93,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (240,            240,     0, 'Peppercorns White Whole',                                                27.55,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (241,            241,     0, 'Poppy Seeds',                                                              9.3,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (242,            242,     0, 'Whole Bay Leaves',                                                         2.0,     1,  0,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (243,            243,     0, 'Medium Himalayan Pink Salt',                                               5.5,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (244,            244,     0, 'Fine Himalayan Pink Salt',                                                 5.5,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (245,            245,     0, 'Ground Savory',                                                          13.13,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (246,            246,     0, 'Ground Thyme',                                                           10.67,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (247,            247,     0, 'Whole Thyme Leaves',                                                     15.93,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (248,            248,     0, 'Ground Turmeric',                                                         8.42,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (249,            249,     0, 'Pickling Spice',                                                          4.01,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (250,            250,     0, 'Table Salt',                                                              0.47,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (251,            251,     0, 'Uncle Larrys Natural Season Salt',                                        7.11,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (252,            252,     0, 'Sea Salt (Food Grade)',                                                   1.01,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (253,            253,     0, 'Real Salt',                                                               4.65,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (254,            254,     0, 'Natural Cajun Seasoning, No MSG Added',                                  10.41,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (255,            255,     0, 'Taco Seasoning',                                                          7.46,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (256,            256,     0, 'Montana Natural Steak Seasoning',                                        12.22,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (257,            257,     0, 'Natural Jamaican Jerk Seasoning',                                          8.9,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (258,            258,     0, 'Natural Hickory Smoke Salt',                                              8.36,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (259,            259,     0, 'Natural Lemon Pepper',                                                     9.1,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (260,            260,     0, 'Chicken BBQ Poultery Seasoning',                                          36.0,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (261,            261,     0, 'Ground Sage',                                                            16.42,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (262,            262,     0, 'Whole Rosemary',                                                          5.99,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (263,            263,     0, 'Rosemary Ground',                                                         6.83,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (264,            264,     0, 'Natural Pumpkin Pie Spice',                                              12.29,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (265,            265,     0, 'Wasabi Green Peas',                                                       6.85,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (266,            266,     0, 'Seasoned Rye Bread Chips',                                                 6.3,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (267,            267,     0, 'Garlic Bagel Chips',                                                      5.31,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (268,            268,     0, 'Pecan Bowlby Bits',                                                       9.11,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (269,            269,     0, 'Crisp Vegetable Chips',                                                   9.64,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (270,            270,     0, 'Salted Corn Chips with Flax',                                             3.05,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (271,            271,     0, 'Honey Mustard and Onion Sesame Sticks',                                   3.63,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (272,            272,     0, 'Wide Sesame Sticks',                                                      3.51,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (273,            273,     0, 'Deluxe Snak-ems Mix',                                                     6.38,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (274,            274,     0, 'Everything Sesame Sticks',                                                3.54,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (275,            275,     0, 'Oriental Rice',                                                           3.44,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (276,            276,     0, 'Little Ones',                                                             2.84,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (277,            277,     0, 'Reese\'s Peanut Butter Chips 4M',                                         5.28,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (278,            278,     0, 'Cinnamon Drops',                                                          4.44,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (279,            279,     0, 'Coconut Oil',                                                             6.36,     1,  0,  12,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (280,            280,     0, 'Creamline Chocolate Milk',                                                1.39,  16.0,  3,  25,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (281,            281,     0, 'Creamline Half & Half',                                                   2.07,  16.0,  3,  25,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (282,            282,     0, 'Creamline Whole Milk',                                                    1.29,  16.0,  3,  25,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (283,            283,     0, 'Black Cherry, Soda',                                                      1.59,  12.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (284,            284,     0, 'Creamy Red Birch Beer, Soda',                                             1.59,  12.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (285,            285,     0, 'Root Beer, Soda',                                                         1.59,  12.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (286,            286,     0, 'Grape, Soda',                                                             1.59,  12.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (287,            287,     0, 'Orange, Soda',                                                            1.59,  12.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (288,            288,     0, 'Creamline Chocolate Milk',                                                3.58,   0.5,  8,  25,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (289,            289,     0, 'Creamline Chocolate Milk',                                                5.79,     1,  8,  25,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (290,            290,     0, 'Cane Cola, Soda',                                                         1.59,  12.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (291,            291,     0, 'Creme, Soda',                                                             1.59,  12.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (292,            292,     0, 'Birch Beer, Soda',                                                        1.59,  12.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (293,            293,     0, 'Ginger Ale, Soda',                                                        1.59,  12.0,  3,  26, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (294,            294,     0, 'Creamline Whole Milk',                                                    3.09,   0.5,  8,  25,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (295,            295,     0, 'Creamline Whole Milk',                                                    4.96,     1,  8,  25,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (296,            296,     0, 'Creamline Skim Milk',                                                     2.84,   0.5,  8,  25,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (297,            297,     0, 'Apple Cider, Gluten Free',                                                1.99,     1,  0,  27,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (298,            298,     0, 'Old Fashoned Chocolate Fudge',                                            9.66,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (299,            299,     0, 'Sea Salted Caramel Fudge',                                                9.66,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (300,            300,     0, 'Creamline 2% Reduced Fat Milk',                                           2.95,  64.0,  3,  25,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (301,            301,     0, 'Apple Cider Vinegar All Natural Drink, Ginger Spice',                     2.79,  16.0,  3,  14,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (302,            302,     0, 'Apple Cider Vinegar All Natural Drink, Apple Cider Vinegar & Honey',      2.79,  16.0,  3,  14,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (303,            303,     0, 'Apple Cider Vinegar All Natural Drink, Concord Grape - Acai',             2.79,  16.0,  3,  14,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (304,            304,     0, '"River Rat" Cheese, Chunky Bleu Flavor',                                   4.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (305,            305,     0, '"River Rat" Cheese, Jalapeno',                                             4.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (306,            306,     0, '"River Rat" Cheese, Garden Vegetable',                                     4.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (307,            307,     0, '"River Rat" Cheese, Aged Asiago',                                          4.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (308,            308,     0, '"River Rat" Cheese, Sharp Cheddar',                                        4.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (309,            309,     0, '"River Rat" Cheese, Swiss & Almond',                                       4.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (310,            310,     0, '"River Rat" Cheese, Smokey Bacon Flavor',                                  4.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (311,            311,     0, '"River Rat" Cheese, Garlic & Herb',                                        4.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (312,            312,     0, 'Hotsie Totsie Pepper Jack Cheese',                                         5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (313,            313,     0, 'Wasabi Cheese NYS Cheddar',                                                5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (314,            314,     0, '3 Year Old XXX Cheddar Cheese',                                            5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (315,            315,     0, 'Sharp Chessar Cheese',                                                     5.5,   8.0,  2,  28, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (316,            316,     0, 'Mild Cheddar Cheese',                                                      5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (317,            317,     0, '8 Year Old Cheddar Cheese',                                                8.0,   8.0,  2,  28, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (318,            318,     0, 'Extra Sharp Cheddar Cheese',                                               5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (319,            319,     0, 'Mean & Nasty Cheddar',                                                     6.2,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (320,            320,     0, 'Maple Cheese NYS Cheddar',                                                 5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (321,            321,     0, 'Date N\' Nut Roll',                                                       5.91,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (322,            322,     0, 'Toasted Onion Cheese',                                                     5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (323,            323,     0, 'Beer Kaese (Milk Limburger)',                                            10.99,     1,  1,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (324,            324,     0, 'Horseradish & Smoked Bacon Cheese',                                        5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (325,            325,     0, 'Muenster Cheese',                                                          6.0,  10.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (326,            326,     0, 'Jalapeno & Cayenne Pepper Cheese',                                         5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (327,            327,     0, 'Pepperoni Cheese',                                                        9.99,     1,  1,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (328,            328,     0, 'Hot Buffalo Bill Cheese',                                                  5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (329,            329,     0, 'Cheddaroni',                                                               5.5,   8.0,  2,  28, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (330,            330,     0, 'Roasted Garlic Cheese',                                                    5.5,   8.0,  2,  28, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (331,            331,     0, 'Hickory Smoked Cheese',                                                    5.5,   8.0,  2,  28, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (332,            332,     0, 'Hot Horseradish "River Rat" Cheese',                                       5.5,   7.0,  2,  28, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (333,            333,     0, 'Horseradish Cheese',                                                       5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (334,            334,     0, 'Spicy Bacon Cheddar',                                                      5.5,   8.0,  2,  28,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (335,            335,     0, 'Large Flake Nutritional Yeast',                                          14.95,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (336,            336,     0, 'Large Medjool Dates',                                                     8.64,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (337,            337,     0, 'Whole Fancy Pitted Dates',                                                4.06,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (338,            338,     0, 'Chopped Dates with Oat Flour',                                             3.0,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (339,            339,     0, 'Honey Mustard',                                                            3.3,  13.0,  2,  29,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (340,            340,     0, 'Honey Butter, Cinnemon',                                                  3.79,   8.0,  2,  30,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (341,            341,     0, 'Honey Butter, Original',                                                  3.79,   8.0,  2,  30,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (342,            342,     0, 'Almond Paste',                                                           11.76,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (343,            343,     0, 'Poppy Filling',                                                           5.21,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (344,            344,     0, 'Natural Creamery Butter',                                                 3.69,     1,  1,  31,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (345,            345,     0, 'Eggs, Dozen Grade A, Large',                                              1.99,  24.0,  2,  32,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (346,            346,     0, 'Eggs, Dozen Grade A, Extra Large',                                        1.99,  27.0,  2,  32,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (347,            347,     0, 'One Pound Granulated Maple Sugar',                                        18.2,     1,  1,  33,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (348,            348,     0, 'Maple Syrup, Grade A Dark, Robust',                                       15.6, 500.0,  4,  33,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (349,            349,     0, 'Maple Syrup, Grade A Dark, Robust',                                        6.5,  50.0,  4,  33,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (350,            350,     0, 'Maple Syrup, Grade A Golden, Delicate',                                   10.5, 250.0,  4,  33,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (351,            351,     0, 'Pure Honey, Fall Flower',                                                 20.0,   3.0,  1,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (352,            352,     0, 'Pure Honey, Fall Flower',                                                 25.0,   5.0,  1,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (353,            353,     0, 'Pure Honey, Bass Wood',                                                   10.0,   2.0,  1,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (354,            354,     0, 'Pure Honey, Fall Flower',                                                  6.5,     1,  1,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (355,            355,     0, 'Pure Honey, Buckwheat',                                                   6.25,     1,  1,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (356,            356,     0, 'Pure Honey, Creamed Honey',                                               7.99,     1,  1,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (357,            357,     0, 'Pure Maple Syrup, Grade A Dark, Robust, NY',                              9.25,  16.0,  3,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (358,            358,     0, 'Pure Honey, Fall Flower',                                                  5.0,  12.0,  2,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (359,            359,     0, 'Pure Maple Syrup, Grade A Amber, Rich, NY',                                4.0,   3.4,  3,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (360,            360,     0, 'Pure Honey, Wild Flower',                                                  2.0,   2.0,  2,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (361,            361,     0, 'Pure Honey, Bass Wood',                                                   7.99,     1,  1,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (362,            362,     0, 'Pure Maple Syrup, Grade A Dark, Robust, NY',                              15.0,  32.0,  3,  34,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (363,            363,     0, 'Pure Maple Syrup, Grade A Amber, Rich, NY',                               28.0,  64.0,  3,  34, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (364,            364,     0, 'Pure Maple Syrup, Grade A Amber, Rich, NY',                               50.0, 128.0,  3,  34, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (365,            365,     0, 'Pure Maple Syrup, Grade A Amber, Rich, NY',                               52.0,     1,  8,  34, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (366,            366,     0, 'Pure Maple Syrup, Grade A Dark, Robust, NY',                              28.0,   0.5,  8,  34, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (367,            367,     0, 'Pure Maple Syrup, Grade A Golden, Delicate, NY',                          2.49,  40.0,  4,  34, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (368,            368,     0, 'Pure Maple Syrup, Grade A Golden, Delicate, NY',                          3.99,  30.0,  4,  34, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (369,            369,     0, 'Hulled Raw Sesame Seeds',                                                 4.23,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (370,            370,     0, 'Pine Nuts (Pignolias)',                                                  27.85,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (371,            371,     0, 'Natural Roasted & Salted Pistachios 21/25',                              11.37,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (372,            372,     0, 'Raw Pumpkin Seeds',                                                       6.19,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (373,            373,     0, 'Roasted & Salted Sunflower Seeds in the Shell',                           1.42,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (374,            374,     0, 'Roasted & Salted Sunflower Meats',                                        2.75,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (375,            375,     0, 'Raw Sunflower Meats',                                                     2.67,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (376,            376,     0, 'Brown Flaxseet Meal',                                                     2.21,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (377,            377,     0, 'Brown Flaxseed',                                                          1.57,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (378,            378,     0, 'Golden Flaxseed',                                                          2.2,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (379,            379,     0, 'Dry Roasted Split Peanuts',                                               2.86,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (380,            380,     0, 'Roasted & Salted Mixed Nuts with Peanuts',                                7.55,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (381,            381,     0, 'Fancy Raw Cashew Pieces',                                                10.19,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (382,            382,     0, 'Honey Toasted Cashews',                                                  14.69,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (383,            383,     0, 'Roasted & Salted Extra Large Peanuts',                                    3.46,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (384,            384,     0, 'Whole Blanched Medium Almonds',                                           7.53,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (385,            385,     0, 'No Salt #1 Spanish Peanuts',                                              2.79,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (386,            386,     0, 'Roasted & Salted Almonds 25/27',                                          8.46,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (387,            387,     0, 'Mixed Nuts Whole',                                                        4.42,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (388,            388,     0, 'Chocolate Raspberry Truffle Snack Mix',                                    7.4,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (389,            389,     0, 'Wake Up Crunch Snack Mix',                                                5.65,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (390,            390,     0, 'Raspberry Nut Supreme Snack Mix',                                         8.93,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (391,            391,     0, 'Raw Walnut Halves and Pieces Combo',                                      5.81,   8.0,  2,  02, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (392,            392,     0, 'Breton Original Bites',                                                   2.55,   8.0,  2,  35, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (393,            393,     0, 'Breton Veggie Bites',                                                     2.55,   8.0,  2,  35, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (394,            394,     0, 'Goji Berry Health Mix',                                                   7.51,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (395,            395,     0, 'Nut-tritious Health Mix',                                                11.56,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (396,            396,     0, 'Milk Chocolate Cashews',                                                  7.22,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (397,            397,     0, 'Coffee & Cream Expresso Beans',                                           5.84,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (398,            398,     0, 'Milk Chocolate Sunflower Seeds',                                          4.64,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (399,            399,     0, 'Greek Yogurt Covered Pretzels',                                           4.61,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (400,            400,     0, 'Chocolate Coated Pretzle Balls',                                          5.24,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (401,            401,     0, 'Milk Chocolate Double Dipped peanuts',                                    6.41,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (402,            402,     0, 'Red Chocolate Cherries',                                                 10.75,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (403,            403,     0, 'Dark Chocolate Turbinado Almonds',                                        6.47,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (404,            404,     0, 'Dark Chocolate Almonds',                                                  8.86,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (405,            405,     0, 'Mini Dark Chocolate Peanut Butter Buckeyes',                              5.46,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (406,            406,     0, 'Dark Chocolate Cashews',                                                   8.2,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (407,            407,     0, 'Dark Chocolate Expresso Beans',                                           8.72,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (408,            408,     0, 'Dark Chocolate Dried Cranberries',                                        6.01,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (409,            409,     0, 'Dark Chocolate Cherries',                                                 8.49,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (410,            410,     0, 'Mini Dark Chocolate Peanut Butter Cups',                                  5.46,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (411,            411,     0, 'Dark Chocolate Malted Balls',                                             5.94,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (412,            412,     0, 'Dark Chocolate Mini Pretzels',                                            5.05,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (413,            413,     0, 'Dark Chocolate Ginger',                                                   6.01,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (414,            414,     0, 'Mini Dark Chocolate Raspberry Cups',                                      4.98,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (415,            415,     0, 'Dark Chocolate Raisins',                                                  5.05,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (416,            416,     0, 'Dark Chocolate Pretzel Balls',                                            6.12,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (417,            417,     0, 'Chocolate Pretzel Grahams',                                               4.87,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (418,            418,     0, 'Boston Baked Beans',                                                      3.65,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (419,            419,     0, 'Wasabi Peanut Crunchies',                                                 3.44,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (420,            420,     0, 'Haviland Nonparells',                                                     5.25,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (421,            421,     0, 'Melon Slices',                                                            3.89,   8.0,  2,  05, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (422,            422,     0, '100% Natural Mango Slices',                                               5.55,   4.5,  2,  05,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (423,            423,     0, 'Cantaloupe Soft Dry',                                                     4.76,   7.0,  2,  05, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (424,            424,     0, 'Pineapple Rings 100% Natural',                                            4.76,   4.5,  2,  05, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (425,            425,     0, 'Coconut Strips',                                                          3.89,   6.0,  2,  05, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (426,            426,     0, 'Ladyfinger Popcorn',                                                      1.93,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (427,            427,     0, 'Red Popcorn',                                                             1.17,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (428,            428,     0, 'Brenon Original Crackers',                                                2.89,     1,  0,  35, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (429,            429,     0, 'Dried Blueberries',                                                       9.65,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (430,            430,     0, 'Tropical Fruit Trio',                                                     6.65,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (431,            431,     0, 'Pineapple Tidbits',                                                       4.34,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (432,            432,     0, 'Diced Turkish Apricots',                                                  3.59,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (433,            433,     0, 'Raspberry Flavored Cranberry Pieces',                                     5.52,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (434,            434,     0, 'Sweetened Banana Chips',                                                  2.58,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (435,            435,     0, 'Dried Cranberries',                                                       3.69,  12.0,  2,  02, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (436,            436,     0, 'Dried Sweet Cherries(Bing)',                                             11.87,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (437,            437,     0, 'Medium White Popcorn',                                                    1.11,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (438,            438,     0, 'Dried Tart Cherries',                                                     9.28,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (439,            439,     0, 'Mango Slices',                                                            5.22,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (440,            440,     0, 'California Sun Dried Rasins',                                             2.32,  15.0,  2,  36,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (441,            441,     0, 'Crystallized Ginger Slices',                                              5.71,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (442,            442,     0, 'Goji Berries',                                                           15.16,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (443,            443,     0, 'Turkish Apricots',                                                        4.35,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (444,            444,     0, 'Natural Creamy Peanut Butter',                                            4.19,  15.0,  2,  37,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (445,            445,     0, 'Peacan Pumpkin Butter',                                                   2.99,   9.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (446,            446,     0, 'Peach Jam',                                                               3.79,   9.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (447,            447,     0, 'Natural Creamy Peanut Butter',                                            8.19,  32.0,  2,  37,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (448,            448,     0, 'Strawberry Rhubarb Butter',                                               3.69,   9.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (449,            449,     0, 'Peach Butter',                                                            3.59,   9.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (450,            450,     0, 'Apple Butter',                                                            3.09,   9.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (451,            451,     0, 'Red Raspberry Jam',                                                       3.09,   9.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (452,            452,     0, 'Elderberry Jelly',                                                        3.99,   9.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (453,            453,     0, 'Strawberry Jam',                                                          3.19,   9.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (454,            454,     0, 'Medium Salsa',                                                            3.59,  14.5,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (455,            455,     0, 'Corn Salsa',                                                              3.59,  14.5,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (456,            456,     0, 'Milk Salsa',                                                              3.59,  14.5,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (457,            457,     0, 'Hot Salsa',                                                               3.59,  14.5,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (458,            458,     0, 'Whole Baby Dill Pickles',                                                 6.39,  32.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (459,            459,     0, 'Pickled Baby Beets',                                                      4.89,  15.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (460,            460,     0, 'Garlic & Jalapen Stuffed Olives',                                         5.59,   8.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (461,            461,     0, 'Dill Pickle Spears',                                                      4.79,  15.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (462,            462,     0, 'Lime Pickles',                                                            5.09,  16.0,  3,  38,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (463,            463,     0, 'Bread & Butter Pickles',                                                  4.79,  15.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (464,            464,     0, 'Pickled Snap Peas',                                                       5.19,  16.0,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (465,            465,     0, 'Hot Pickled Mushrooms',                                                   6.09,  12.5,  2,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (466,            466,     0, 'Sweet Pickled Garlic',                                                    6.59,  16.0,  2,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (467,            467,     0, 'Sauerkraut',                                                              4.69,  16.0,  2,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (468,            468,     0, 'Sweet Garlic Dill Pickles',                                               4.59,  15.0,  2,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (469,            469,     0, 'Sweet Pickled Gherkins',                                                  4.59,  15.0,  2,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (470,            470,     0, 'Pickled Dilly Beans',                                                     4.59,  15.0,  2,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (471,            471,     0, 'Pickled Dilly Corn',                                                      4.59,  15.0,  2,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (472,            472,     0, 'Garden Vegetable Soup, no MSG Added',                                     6.64,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (473,            473,     0, 'Natural Harvest Soup Mix, no MSG Added',                                  3.72,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (474,            474,     0, 'Black Turtle Beans',                                                      1.44,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (475,            475,     0, 'Garbanzo Beans',                                                          2.49,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (476,            476,     0, 'French Onion Soup Mix',                                                   6.86,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (477,            477,     0, 'Yellow Split Peas',                                                        1.6,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (478,            478,     0, 'Hearty Soup Mix',                                                         2.69,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (479,            479,     0, 'Natural Holiday Soup Mix',                                                2.17,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (480,            480,     0, 'Chunky Potato Soup Mix',                                                  3.91,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (481,            481,     0, 'Green Split Peas',                                                        3.42,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (482,            482,     0, 'Natual 13 Bean Soup Mix',                                                 2.93,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (483,            483,     0, 'Navy Beans',                                                              1.78,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (484,            484,     0, 'Food Grade Millet',                                                       0.67,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (485,            485,     0, 'Pearled Barley',                                                          1.51,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (486,            486,     0, 'Lentils',                                                                 2.27,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (487,            487,     0, 'Pinto Beans',                                                             1.11,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (488,            488,     0, 'White Distilled Vinegar, 4%',                                             3.99, 128.0,  3,  39,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (489,            489,     0, 'Oatmeal Bread, Homemade',                                                 2.99,     1,  0,  40,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (490,            490,     0, 'Multigrain, Homemade Bread',                                              3.29,     1,  0,  40,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (491,            491,     0, 'Honey Wheat, Homemade Bread',                                             2.99,     1,  0,  40,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (492,            492,     0, 'Chocolate Chocolate Chip Cookies',                                        1.29,   2.0,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (493,            493,     0, 'Ginger Softs, Cookies',                                                   1.29,   2.0,  0,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (494,            494,     0, 'Chocolate Chip Cookies',                                                  1.29,   2.0,  0,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (495,            495,     0, 'Farm Style Oatmeal, Cookies',                                             1.29,   2.0,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (496,            496,     0, 'Pumpkin Chocolate Chip, Cookies',                                         1.29,   2.0,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (497,            497,     0, 'White Bread, Homemade',                                                   2.99,     1,  0,  40, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (498,            498,     0, 'Hummus Dip',                                                              2.99,     1,  0,  41, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (499,            499,     0, 'Fall Leaf Shapes',                                                        8.93,     1,  0,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (500,            500,     0, 'Autumn Sprinkles',                                                        6.29,     1,  0,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (501,            501,     0, 'Pretzel Shells, Original',                                                2.49,  10.0,  2,  42, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (502,            502,     0, 'Nut-Thins, Almond',                                                       3.69,  4.25,  2,  43, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (503,            503,     0, 'Honey Lemon Menthol Cough Drops',                                         4.48,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (504,            504,     0, 'Sanded Cinnamon Drops',                                                   2.25,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (505,            505,     0, 'Anise Balls',                                                             2.45,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (506,            506,     0, 'Deluxe Candy Mix',                                                        2.55,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (507,            507,     0, 'Mini Tootsie Roll Midgees',                                               4.09,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (508,            508,     0, 'Sesame Crunch',                                                           5.19,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (509,            509,     0, 'Stick Candy',                                                             0.37,   0.5,  2,  44, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (510,            510,     0, 'White Mint Lozenges',                                                     4.38,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (511,            511,     0, 'Clove Balls',                                                             2.74,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (512,            512,     0, 'Sanded Sassafras Drops',                                                  2.25,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (513,            513,     0, 'Light Green Spearmint Lozenges',                                          2.61,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (514,            514,     0, 'Atomic Fireball',                                                         1.68,   8.0,  2,  02, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (515,            515,     0, 'Spearmint Starlites',                                                     3.16,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (516,            516,     0, 'Sugar Free IBC Root Beer Floats',                                          6.6,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (517,            517,     0, 'Assorted Jelly Beans',                                                    2.42,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (518,            518,     0, 'Sugar Free Butterscotch Candy',                                           7.91,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (519,            519,     0, 'Sugar Free Cinnamon Candy',                                               8.47,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (520,            520,     0, 'Root Beer Barrels',                                                       3.37,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (521,            521,     0, 'Gummi Chicken Feet',                                                       4.7,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (522,            522,     0, 'Gummi Peach Rings',                                                       2.53,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (523,            523,     0, 'Gummi Bear Cubs',                                                         4.51,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (524,            524,     0, 'Candy Blox',                                                              5.35,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (525,            525,     0, 'Mini Red Swedish Fish',                                                   4.38,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (526,            526,     0, 'Candy Corn',                                                               2.6,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (527,            527,     0, 'Peanut Brittle',                                                          3.03,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (528,            528,     0, 'Raspberry Whole Wheat Fig Bars',                                          5.14,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (529,            529,     0, 'Honey Process Coffee',                                                    11.5,   8.0,  2,  48, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (530,            530,     0, 'Mayan Warrior Blend',                                                     12.0,  12.0,  2,  48, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (531,            531,     0, '435 deg Medium Dark Roast',                                               12.0,  12.0,  2,  48, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (532,            532,     0, '425 deg Medium Roast',                                                    12.0,  12.0,  2,  48, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (533,            533,     0, '415 deg Light Medium Roast',                                              12.0,  12.0,  2,  48, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (534,            534,     0, 'Licorice Rockies',                                                        6.17,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (535,            535,     0, 'Cherry Slices',                                                           2.14,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (536,            536,     0, 'Strawberry Licorice Wheels',                                              4.17,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (537,            537,     0, 'Red and Black Berries',                                                   3.75,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (538,            538,     0, 'Caramel Creams',                                                          3.79,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (539,            539,     0, 'Spearmint Leaves',                                                        2.35,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (540,            540,     0, 'Orange Slices',                                                           2.14,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (541,            541,     0, 'Natural Strawberry Dip Mix, No MSG Added',                                6.79,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (542,            542,     0, 'Natural Black Raspberry Dip Mix, No MSG Added',                           7.06,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (543,            543,     0, 'Natural Caramel Apple Dip & Dessert Mix, No MSG Added',                   5.77,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (544,            544,     0, 'Australian Style Black Licorice',                                         5.12,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (545,            545,     0, 'Pumpkin?',                                                               24.69,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (546,            546,     0, 'Smooth \'N Melty Petite Mints',                                           6.81,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (547,            547,     0, 'Box Sign Toilet Paper',                                                   9.99,     1,  0,  08, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (548,            548,     0, 'Nesting Tins, We Gather Here With Thankful Hearts',                      24.99,     1,  0,  11, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (549,            549,     0, 'String Box Sign - Pumpkin',                                               9.99,     1,  0,  08, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (550,            550,     0, 'Travel Mug',                                                              9.99,     1,  0,  11, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (551,            551,     0, 'Domino Dark Brown Sugar',                                                  1.3,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (552,            552,     0, 'Light Brown Sugar',                                                       1.34,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (553,            553,     0, 'Domino 10X Sugar',                                                        1.27,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (554,            554,     0, 'American Beauty Hi-Rise-Cake Flour',                                      0.39,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (555,            555,     0, 'Sir Lancelot Hi-Gluten Flour',                                            0.56,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (556,            556,     0, 'Unbleached Occident Flour',                                               0.95,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (557,            557,     0, 'Fine Yellow Cornmeal',                                                    0.69,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (558,            558,     0, 'Medium Rye Meal Pumpernickle Flour',                                      1.04,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (559,            559,     0, 'GM All Trumps Flour',                                                     0.92,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (560,            560,     0, 'King Arthur Special Flour',                                               0.85,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (561,            561,     0, 'Pie and Pastery Flour',                                                   0.71,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (562,            562,     0, 'H&R Self-Rising Flour',                                                   0.65,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (563,            563,     0, 'Ultragrain White Whole Wheat Flour',                                      0.78,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (564,            564,     0, 'Whole Wheat Pire and Pastry Flour',                                       0.63,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (565,            565,     0, 'Hulled Barley Flakes',                                                    0.92,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (566,            566,     0, 'Steel Cut Oat Groats',                                                     1.0,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (567,            567,     0, 'Rolled and Flaked 7-Grain Mix with Flax',                                 1.92,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (568,            568,     0, 'Thick Rolled Oats #3',                                                    0.95,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (569,            569,     0, 'Medium Rolled Oats #4',                                                   1.02,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (570,            570,     0, 'Baker\'s Bran (Wheat)',                                                   0.62,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (571,            571,     0, 'Quick Oats',                                                              0.93,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (572,            572,     0, 'Baby Flake Oats',                                                         1.58,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (573,            573,     0, 'Whole Oat Groats',                                                        0.99,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (574,            574,     0, 'Oat Bran',                                                                0.97,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (575,            575,     0, 'Cracked 9-Grain Mix',                                                     2.32,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (576,            576,     0, 'Gluten Free All Purpose Flour',                                           3.17,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (577,            577,     0, 'All Purpose Organic Flour, Unbleached White',                              9.4,   5.0,  1,  03, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (578,            578,     0, 'Whole Wheat Organic Flour, 100% Stone Ground',                            6.05,   3.0,  1,  03, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (579,            579,     0, 'Coarse Cracked Wheat',                                                    0.77,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (580,            580,     0, 'Gluten Free Brown Rice Flour',                                            1.73,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (581,            581,     0, 'Semolina Flour',                                                          1.35,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (582,            582,     0, 'Dark Rye Flour',                                                           1.1,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (583,            583,     0, 'Gluten Free Blanched Almond Meal/Flour',                                  10.9,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (584,            584,     0, 'Organic Coconut Flour',                                                   2.83,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (585,            585,     0, 'Gluten Free White Rice Flour',                                            1.65,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (586,            586,     0, 'Premium 100% Whole Wheat Flour',                                           9.0,  10.0,  1,  07, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (587,            587,     0, 'Xylitol',                                                                 7.78,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (588,            588,     0, 'White Hominy Grits',                                                      1.24,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (589,            589,     0, 'Very Berry Anti-Ox Muesli',                                               5.54,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (590,            590,     0, 'Premium 100% Whole Wheat Flour',                                          6.44,   5.0,  1,  07,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (591,            591,     0, 'Natural Swiss-Style Muesli',                                              4.19,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (592,            592,     0, 'Demerara Unrefined Sugar',                                                1.13,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (593,            593,     0, 'Organic Coconut Palm Sugar',                                              3.99,     1,  1,  45,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (594,            594,     0, 'Garbanzo Bean Flour',                                                     2.94,     1,  1,  03,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (595,            595,     0, 'Potato Starch',                                                            4.7,     1,  1,  03,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (596,            596,     0, 'Wheat Germ',                                                              2.84,  0.12,  2,  03,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (597,            597,     0, 'Old Fashioned Buckwheat Pancake Mix',                                     8.39,   5.0,  1,  46,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (598,            598,     0, 'Old Fashioned Roled Oats, Wheat Free, Gluten Free, Dairy Free',           7.95,  32.0,  2,  03,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (599,            599,     0, '10 Grain Hot Cereal',                                                     4.46,  25.0,  2,  03, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (600,            600,     0, 'Buckwheat Flour, Whole Grain',                                            5.17,  22.0,  2,  03,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (601,            601,     0, 'Brown Rice Flour, Whole Grain',                                            4.0,  24.0,  2,  03,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (602,            602,     0, 'Barley Flour, Stone Ground',                                              3.15,  20.0,  2,  03, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (603,            603,     0, 'Spelt Flour, Whole Grain, Stone Ground',                                   4.7,  24.0,  2,  03,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (604,            604,     0, 'Tapioca Flour, Finely Ground',                                            4.29,     1,  0,  03,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (605,            605,     0, 'Vital Wheat Gluten',                                                      3.44,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (606,            606,     0, 'Shortbreak Cookie Mix, Wheat Free, Gluten Free, Dairy Free',              4.29,  21.0,  2,  03,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (607,            607,     0, 'Complete Restaurant Style Pancake Mix',                                   3.29,  32.0,  2,  46,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (608,            608,     0, 'Rye Berries',                                                             1.43,     1,  1,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (609,            609,     0, 'Premium All-Purpose Flour, Natural White',                                5.99,   5.0,  1,  07,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (610,            610,     0, 'Chocolate Chip Cookie Mix, Gluten Free',                                  6.36,  22.0,  2,  03,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (611,            611,     0, 'Bulgur Wheat Cereal',                                                      0.9,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (612,            612,     0, 'Vanilla Yellow Cake Mix, Gluten Free',                                    4.29,  19.0,  2,  03, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (613,            613,     0, 'Buttermilk Pancake Mix',                                                  3.29,  32.0,  2,  46, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (614,            614,     0, 'Brownie Mix, Gluten Free',                                                5.63,  21.0,  2,  03, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (615,            615,     0, 'Pumpkin Spice Pancake & Muffin Mix',                                      3.49,  24.0,  2,  46, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (616,            616,     0, 'Multi-Seed, Original',                                                    2.99,   4.5,  2,  47, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (617,            617,     0, 'Long Lufa',                                                               4.99,     1,  0,  20,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (618,            618,     0, 'Lantern Small',                                                          23.99,     1,  0,  00,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (619,            619,     0, '"River Rat" Port Wine Cheese',                                             4.5,   8.0,  2,  28, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (620,            620,     0, 'Mild Cheedar Cheese',                                                      5.5,     1,  1,  28, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (621,            621,     0, 'Ginger Snaps',                                                            2.98,     1,  1,  00, false);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (283,            622,     0, 'Black Cherry, Soda (4-pack)',                                             4.99,  60.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (284,            623,     0, 'Creamy Red Birch Beer, Soda (4-pack)',                                    4.99,  60.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (285,            624,     0, 'Root Beer, Soda (4-pack)',                                                4.99,  60.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (286,            625,     0, 'Grape, Soda (4-pack)',                                                    4.99,  60.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (287,            626,     0, 'Orange, Soda (4-pack)',                                                   4.99,  60.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (290,            627,     0, 'Cane Cola, Soda (4-pack)',                                                4.99,  60.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (291,            628,     0, 'Creme, Soda (4-pack)',                                                    4.99,  60.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (292,            629,     0, 'Birch Beer, Soda (4-pack)',                                               4.99,  60.0,  3,  26,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (293,            630,     0, 'Ginger Ale, Soda (4-pack)',                                               4.99,  60.0,  3,  26,  true);

																										
																																																			
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (1000, 1000,   12, 'Chicken Barbeque, Plate',                                                 8.79, NULL,   0,  0,  true);
INSERT INTO Item(UPC, ItemCode, InStock, Description, Price, Weight, MeasID, ManufID, EaYN) VALUES (1001, 1001,   12, 'Chicken Barbeque, Meal',                                                 11.79, NULL,   0,  0,  true);

INSERT INTO Seasonal_Item(ItemCode, StartDate, EndDate) VALUES (1000, '0000-10-01', '0000-02-01');
INSERT INTO Seasonal_Item(ItemCode, StartDate, EndDate) VALUES (1001, '0000-10-01', '0000-02-01');

INSERT INTO Item_Category(ItemCode, CatID) VALUES (1, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (2, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (3, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (4, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (5, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (6, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (7, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (8, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (9, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (10, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (11, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (12, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (13, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (14, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (15, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (16, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (17, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (18, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (19, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (23, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (24, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (25, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (26, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (27, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (28, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (29, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (30, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (31, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (32, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (33, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (34, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (35, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (36, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (37, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (38, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (39, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (40, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (41, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (42, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (43, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (44, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (45, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (46, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (47, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (48, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (49, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (50, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (51, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (52, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (53, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (54, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (55, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (56, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (57, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (58, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (59, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (60, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (61, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (62, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (63, 14);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (64, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (65, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (66, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (67, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (68, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (69, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (70, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (71, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (72, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (73, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (74, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (75, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (76, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (77, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (78, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (79, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (80, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (81, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (82, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (83, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (84, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (85, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (86, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (87, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (88, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (89, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (90, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (91, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (92, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (93, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (94, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (95, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (96, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (97, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (98, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (99, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (100, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (101, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (102, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (103, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (104, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (105, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (106, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (107, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (108, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (109, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (110, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (111, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (112, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (113, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (114, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (115, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (116, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (117, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (118, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (119, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (120, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (121, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (122, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (123, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (124, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (125, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (126, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (127, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (128, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (129, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (130, 14);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (131, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (132, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (133, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (134, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (135, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (136, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (137, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (138, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (139, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (140, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (141, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (142, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (143, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (144, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (145, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (146, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (147, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (148, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (149, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (150, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (151, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (152, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (153, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (154, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (155, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (156, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (157, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (158, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (159, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (160, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (161, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (162, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (163, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (164, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (165, 4);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (166, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (167, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (168, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (169, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (170, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (171, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (172, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (173, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (174, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (175, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (176, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (177, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (178, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (179, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (180, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (181, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (182, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (183, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (184, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (185, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (186, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (187, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (188, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (189, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (190, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (191, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (192, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (193, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (194, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (195, 19);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (196, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (197, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (198, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (199, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (200, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (201, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (202, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (203, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (204, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (205, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (206, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (207, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (208, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (209, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (210, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (211, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (212, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (213, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (214, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (215, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (216, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (217, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (218, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (219, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (220, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (221, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (222, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (223, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (224, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (225, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (226, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (227, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (228, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (229, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (230, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (231, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (232, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (233, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (234, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (235, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (236, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (237, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (238, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (239, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (240, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (241, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (242, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (243, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (244, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (245, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (246, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (247, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (248, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (249, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (250, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (251, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (252, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (253, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (254, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (255, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (256, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (257, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (258, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (259, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (260, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (261, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (262, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (263, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (264, 21);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (265, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (266, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (267, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (268, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (269, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (270, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (271, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (272, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (273, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (274, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (275, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (276, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (277, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (278, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (279, 14);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (280, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (281, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (282, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (283, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (284, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (285, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (286, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (287, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (288, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (289, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (290, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (291, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (292, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (293, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (294, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (295, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (296, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (297, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (298, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (299, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (300, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (301, 14);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (302, 14);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (303, 14);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (304, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (305, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (306, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (307, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (308, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (309, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (310, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (311, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (312, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (313, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (314, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (315, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (316, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (317, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (318, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (319, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (320, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (321, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (322, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (323, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (324, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (325, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (326, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (327, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (328, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (329, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (330, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (331, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (332, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (333, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (334, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (335, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (336, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (337, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (338, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (339, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (340, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (341, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (342, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (343, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (344, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (345, 10);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (346, 10);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (347, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (348, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (349, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (350, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (351, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (352, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (353, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (354, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (355, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (356, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (357, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (358, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (359, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (360, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (361, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (362, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (363, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (364, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (365, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (366, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (367, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (368, 7);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (369, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (370, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (371, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (372, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (373, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (374, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (375, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (376, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (377, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (378, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (379, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (380, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (381, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (382, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (383, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (384, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (385, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (386, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (387, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (388, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (389, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (390, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (391, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (392, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (393, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (394, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (395, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (396, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (397, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (398, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (399, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (400, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (401, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (402, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (403, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (404, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (405, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (406, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (407, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (408, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (409, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (410, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (411, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (412, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (413, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (414, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (415, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (416, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (417, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (418, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (419, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (420, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (421, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (422, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (423, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (424, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (425, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (426, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (427, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (428, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (429, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (430, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (431, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (432, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (433, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (434, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (435, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (436, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (437, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (438, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (439, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (440, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (441, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (442, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (443, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (444, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (445, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (446, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (447, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (448, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (449, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (450, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (451, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (452, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (453, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (454, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (455, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (456, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (457, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (458, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (459, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (460, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (461, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (462, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (463, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (464, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (465, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (466, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (467, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (468, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (469, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (470, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (471, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (472, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (473, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (474, 2);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (475, 2);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (476, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (477, 2);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (478, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (479, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (480, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (481, 2);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (482, 2);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (483, 2);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (484, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (485, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (486, 2);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (487, 2);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (488, 14);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (489, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (490, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (491, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (492, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (493, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (494, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (495, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (496, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (497, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (498, 20);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (499, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (500, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (501, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (502, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (503, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (504, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (505, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (506, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (507, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (508, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (509, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (510, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (511, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (512, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (513, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (514, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (515, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (516, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (517, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (518, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (519, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (520, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (521, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (522, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (523, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (524, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (525, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (526, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (527, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (528, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (529, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (530, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (531, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (532, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (533, 6);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (534, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (535, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (536, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (537, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (538, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (539, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (540, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (541, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (542, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (543, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (544, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (545, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (546, 22);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (547, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (548, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (549, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (550, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (551, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (552, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (553, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (554, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (555, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (556, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (557, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (558, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (559, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (560, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (561, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (562, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (563, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (564, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (565, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (566, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (567, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (568, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (569, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (570, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (571, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (572, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (573, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (574, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (575, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (576, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (577, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (578, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (579, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (580, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (581, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (582, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (583, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (584, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (585, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (586, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (587, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (588, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (589, 11);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (590, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (591, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (592, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (593, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (594, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (595, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (596, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (597, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (598, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (599, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (600, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (601, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (602, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (603, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (604, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (605, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (606, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (607, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (608, 13);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (609, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (610, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (611, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (612, 5);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (613, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (614, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (615, 1);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (616, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (617, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (618, 9);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (619, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (620, 8);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (621, 18);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (622, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (623, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (624, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (625, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (626, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (627, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (628, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (629, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (630, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (280, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (282, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (288, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (289, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (294, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (295, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (296, 3);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (300, 3);

-------------------------------------------------------- Zac Insert Statements
INSERT INTO Zip (Zip, City, State) VALUES ('13053', 'Dryden', 'NY');
INSERT INTO Zip (Zip, City, State) VALUES ('13073', 'Groton', 'NY');
INSERT INTO Zip (Zip, City, State) VALUES ('13045', 'Cortland', 'NY');
INSERT INTO Zip (Zip, City, State) VALUES ('28310', 'Spring Lake', 'NC');
INSERT INTO Zip (Zip, City, State) VALUES ('28311', 'Fort Bragg', 'NC');
INSERT INTO Zip (Zip, City, State) VALUES ('28309', 'Fayetteville', 'NC');
INSERT INTO Zip (Zip, City, State) VALUES ('31905', 'Columbus','GA');
INSERT INTO Zip (Zip, City, State) VALUES ('84564', 'Brunsville', 'TX');
INSERT INTO Zip (Zip, City, State) VALUES ('11111', 'Kelpos', 'SC');
INSERT INTO Zip (Zip, City, State) VALUES ('26485', 'Briggstown', 'MN');
INSERT INTO Zip (Zip, City, State) VALUES ('84982', 'Terracor', 'CO');
INSERT INTO Zip (Zip, City, State) VALUES ('91525', 'Selfur', 'MA');

INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('onlineorder@dedricks.com', 'password', 'Store', 'Order', '6251648542');
INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('gottem@gmail.com', 'password', 'Mandy', 'Briggs', '6251648542');
INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('Deeztrucks@yahoo.com', 'password', 'Steven', 'Turry', '9452615842');
INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('purplepeopleeater@hotmail.com', 'paSSword', 'Kassandra', 'Alditore', '1658425478');
INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('ourlordandsaviortachanka@praisehim.com', 'Paddywack', 'Brock', 'Onix', '8459426154');
INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('thisissparta@greeks.com', 'Elysium', 'Patrick', 'Star', '9452145666');
INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('whereintheworldiscarmensadiago@waldo.com', 'Bant', 'Sam', 'Killington', '1111111111');
INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('WILSON!!!@castaways.com', 'Turtles', 'Pedro', 'Sombrero', '2222222222');
INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('minime@justevil.com', 'Goldmember', 'Jane', 'Doe', '3333333333');
INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('owalego@steppedonit.org', 'click', 'John', 'Doe', '4444444444');
INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('admin@mail.com', '$2y$10$L8i7UhH8booYun4c.F56jel5dNw8WH6rU2XrxgHEO1SdwMxjPQdWW', 'Admin', 'Admin', '6077777777');
INSERT INTO AddressBook (Email, Password, FName, LName, Phone) VALUES ('guessthisisithuh@gitgud.net', 'scrubbynoober', 'Trainy', 'McTrainface', '3333333333');

INSERT INTO AddressBook_Optional (InfoID, Addy1, Addy2, Zip) VALUES (1, '123 State Street', 'APT 1', '13053');
INSERT INTO AddressBook_Optional (InfoID, Addy1, Addy2, Zip) VALUES (2, '456 State Street', 'APT 2', '13045');
INSERT INTO AddressBook_Optional (InfoID, Addy1, Addy2, Zip) VALUES (3, 'Here and There Street', 'Up', '13053');
INSERT INTO AddressBook_Optional (InfoID, Addy1, Addy2, Zip) VALUES (4, '1234 Here Street', 'apt 32', '13045');
INSERT INTO AddressBook_Optional (InfoID, Addy1, Addy2, Zip) VALUES (5, '1 Timbucktou St', 'apt 45', '28310');
INSERT INTO AddressBook_Optional (InfoID, Addy1, Addy2, Zip) VALUES (6, '3 Street St', 'apt 12', '28311');
INSERT INTO AddressBook_Optional (InfoID, Addy1, Addy2, Zip) VALUES (7, '3 Sam Hill', 'left', '91525');
INSERT INTO AddressBook_Optional (InfoID, Addy1, Addy2, Zip) VALUES (8, '1 my evil lair St', 'apt 3', '84982');
INSERT INTO AddressBook_Optional (InfoID, Addy1, Addy2, Zip) VALUES (9, '3 Pain Street', 'apt 345', '11111');
INSERT INTO AddressBook_Optional (InfoID, Addy1, Addy2, Zip) VALUES (10,'10 Awesomeness Ave', 'Apt 1', '28309');

INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(1,  'Janitor',    4);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(2,  'Salesman',   1);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(3,  'Stocker',    1);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(4,  'Owner',      5);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(5,  'Craftsman',  2);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(6,  'Tax person', 4);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(7,  'Greeter',    1);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(8,  'Cashier',    2);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(9,  'Interior Lighting', 1);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(10, 'Snooper',    5);

INSERT INTO Employee (EmpID, InfoID, JobID) VALUES(1, 1, 1);
INSERT INTO Employee (EmpID, InfoID, JobID) VALUES(2,2,2);
INSERT INTO Employee (EmpID, InfoID, JobID) VALUES(3,3,3);
INSERT INTO Employee (EmpID, InfoID, JobID) VALUES(4,4,4);
INSERT INTO Employee (EmpID, InfoID, JobID) VALUES(5,5,5);
INSERT INTO Employee (EmpID, InfoID, JobID) VALUES(6,6,6);
INSERT INTO Employee (EmpID, InfoID, JobID) VALUES(7,7,7);
INSERT INTO Employee (EmpID, InfoID, JobID) VALUES(8,8,8);
INSERT INTO Employee (EmpID, InfoID, JobID) VALUES(9,9,9);
INSERT INTO Employee (EmpID, InfoID, JobID) VALUES(10,10,10);

/*
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(1, '12/07/2013', '12/07/2014',1 ,8.17);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(2, '12/08/1994', '09/02/2019',0 ,9.50);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(3, '05/29/1908', '03/18/1790',1 ,10.00);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(4, '11/13/2000', '04/16/2005',0 ,4.50);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(5, '10/22/2001', '05/23/2006',1 ,90.50);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(6, '12/24/1999', '03/31/2006',0 ,20.53);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(7, '11/23/1994', '02/04/2018',1 ,2.91);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(8, '05/17/1845', '12/31/2019',0 ,0.01);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(9, '06/17/1456', '07/25/1954',1 ,1.00);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(10,'07/24/1837', '02/25/1985',0 ,1.50);

INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(1, NOW() - INTERVAL 8 DAY, NULL, 1 ,8.17);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(2, NOW() - INTERVAL 8 DAY, NULL, 0 ,9.51);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, WageYN, Rate) VALUES(3, NOW() - INTERVAL 8 DAY, NULL, 1 ,10.01);


INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(1, '2018-01-01 12:00:00','2018-01-01 13:00:00');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(2, '2018-01-01 13:00:00','2018-01-01 14:00:00');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(3, '2018-01-01 14:00:00','2018-01-01 15:00:00');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(4, '2018-01-01 15:00:00','2018-01-01 16:00:00');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(5, '2018-01-01 16:00:00','2018-01-01 17:00:00');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(6, '2018-01-01 17:00:00','2018-01-01 18:00:00');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(7, '2018-01-01 18:00:00','2018-01-01 19:00:00');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(8, '2018-01-01 19:00:00','2018-01-01 20:00:00');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(9, '2018-01-01 20:00:00','2018-01-01 21:00:00');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(10,'2018-01-01 21:00:00','2018-01-01 23:00:00');


-- Test Records for Query

INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(1, NOW()- INTERVAL 9 DAY, (NOW()- INTERVAL 9 DAY)+INTERVAL 100 HOUR);
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(2, NOW()- INTERVAL 9 DAY, (NOW()- INTERVAL 9 DAY)+INTERVAL 100 HOUR);
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(3, NOW()- INTERVAL 9 DAY, (NOW()- INTERVAL 9 DAY)+INTERVAL 100 HOUR);


INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(1, NOW()- INTERVAL 4 DAY,(NOW()- INTERVAL 4 DAY)+INTERVAL 3 HOUR);
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(2, NOW()- INTERVAL 4 DAY,(NOW()- INTERVAL 4 DAY)+INTERVAL 2 HOUR+INTERVAL 10 MINUTE);
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(3, NOW()- INTERVAL 4 DAY,(NOW()- INTERVAL 4 DAY)+INTERVAL 1 HOUR+INTERVAL 15 MINUTE);

INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(1, NOW()- INTERVAL 3 DAY,(NOW()- INTERVAL 3 DAY)+INTERVAL 1 HOUR);
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(2, NOW()- INTERVAL 3 DAY,(NOW()- INTERVAL 3 DAY)+INTERVAL 1 HOUR+INTERVAL 10 MINUTE);
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(3, NOW()- INTERVAL 3 DAY,(NOW()- INTERVAL 3 DAY)+INTERVAL 9 HOUR+INTERVAL 15 MINUTE);

INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(1, NOW()- INTERVAL 4 HOUR, NULL);
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(2, NOW()- INTERVAL 4 HOUR, NULL);
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(3, NOW()- INTERVAL 4 HOUR, NULL);
*/
----------------------------------------------------------------Josh Insert Statements

INSERT INTO Supplier (SupID,InfoID,AmntPurchased) VALUES (NULL,1,9.99);
INSERT INTO Supplier (SupID,InfoID,AmntPurchased) VALUES (NULL,2,9.99);
INSERT INTO Supplier (SupID,InfoID,AmntPurchased) VALUES (NULL,3,9.99);
INSERT INTO Supplier (SupID,InfoID,AmntPurchased) VALUES (NULL,4,9.99);
INSERT INTO Supplier (SupID,InfoID,AmntPurchased) VALUES (NULL,5,9.99);
INSERT INTO Supplier (SupID,InfoID,AmntPurchased) VALUES (NULL,6,9.99);
INSERT INTO Supplier (SupID,InfoID,AmntPurchased) VALUES (NULL,7,9.99);
INSERT INTO Supplier (SupID,InfoID,AmntPurchased) VALUES (NULL,8,9.99);
INSERT INTO Supplier (SupID,InfoID,AmntPurchased) VALUES (NULL,9,9.99);
INSERT INTO Supplier (SupID,InfoID,AmntPurchased) VALUES (NULL,10,9.99);

INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,2,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,2,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,3,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,4,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,4,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,1,'2018-01-01 10:00:00.000000',9.99);

INSERT INTO Supplied_Item (SupOrderID,ItemCode,DateReceived,DateSellBy,CostPerAmt,AmtSupplied,AmtWasted) VALUES (1,1,'2018-01-01 10:00:00.000000','2018-01-02 10:00:00.000000',9.99,1,0);
INSERT INTO Supplied_Item (SupOrderID,ItemCode,DateReceived,DateSellBy,CostPerAmt,AmtSupplied,AmtWasted) VALUES (2,2,'2018-01-01 10:00:00.000000','2018-01-02 10:00:00.000000',9.99,1,0);
INSERT INTO Supplied_Item (SupOrderID,ItemCode,DateReceived,DateSellBy,CostPerAmt,AmtSupplied,AmtWasted) VALUES (3,3,'2018-01-01 10:00:00.000000','2018-01-02 10:00:00.000000',9.99,1,0);
INSERT INTO Supplied_Item (SupOrderID,ItemCode,DateReceived,DateSellBy,CostPerAmt,AmtSupplied,AmtWasted) VALUES (4,4,'2018-01-01 10:00:00.000000','2018-01-02 10:00:00.000000',9.99,1,0);
INSERT INTO Supplied_Item (SupOrderID,ItemCode,DateReceived,DateSellBy,CostPerAmt,AmtSupplied,AmtWasted) VALUES (5,5,'2018-01-01 10:00:00.000000','2018-01-02 10:00:00.000000',9.99,1,0);
INSERT INTO Supplied_Item (SupOrderID,ItemCode,DateReceived,DateSellBy,CostPerAmt,AmtSupplied,AmtWasted) VALUES (6,6,'2018-01-01 10:00:00.000000','2018-01-02 10:00:00.000000',9.99,1,0);
INSERT INTO Supplied_Item (SupOrderID,ItemCode,DateReceived,DateSellBy,CostPerAmt,AmtSupplied,AmtWasted) VALUES (7,7,'2018-01-01 10:00:00.000000','2018-01-02 10:00:00.000000',9.99,1,0);
INSERT INTO Supplied_Item (SupOrderID,ItemCode,DateReceived,DateSellBy,CostPerAmt,AmtSupplied,AmtWasted) VALUES (8,8,'2018-01-01 10:00:00.000000','2018-01-02 10:00:00.000000',9.99,1,0);
INSERT INTO Supplied_Item (SupOrderID,ItemCode,DateReceived,DateSellBy,CostPerAmt,AmtSupplied,AmtWasted) VALUES (9,9,'2018-01-01 10:00:00.000000','2018-01-02 10:00:00.000000',9.99,1,0);
INSERT INTO Supplied_Item (SupOrderID,ItemCode,DateReceived,DateSellBy,CostPerAmt,AmtSupplied,AmtWasted) VALUES (10,10,'2018-01-01 10:00:00.000000','2018-01-02 10:00:00.000000',9.99,1,0);

INSERT INTO Customer (CustID, InfoID) VALUES (1,1);
INSERT INTO Customer (CustID, InfoID) VALUES (2,2);
INSERT INTO Customer (CustID, InfoID) VALUES (3,3);
INSERT INTO Customer (CustID, InfoID) VALUES (4,4);
INSERT INTO Customer (CustID, InfoID) VALUES (5,5);
INSERT INTO Customer (CustID, InfoID) VALUES (6,6);
INSERT INTO Customer (CustID, InfoID) VALUES (7,7);
INSERT INTO Customer (CustID, InfoID) VALUES (8,8);
INSERT INTO Customer (CustID, InfoID) VALUES (9,9);
INSERT INTO Customer (CustID, InfoID) VALUES (10,10);

INSERT INTO Cart (CartID) VALUES (1);
INSERT INTO Cart (CartID) VALUES (2);
INSERT INTO Cart (CartID) VALUES (3);
INSERT INTO Cart (CartID) VALUES (4);
INSERT INTO Cart (CartID) VALUES (5);
INSERT INTO Cart (CartID) VALUES (6);
INSERT INTO Cart (CartID) VALUES (7);
INSERT INTO Cart (CartID) VALUES (8);
INSERT INTO Cart (CartID) VALUES (9);
INSERT INTO Cart (CartID) VALUES (10);
INSERT INTO Cart (CartID) VALUES (11);
INSERT INTO Cart (CartID) VALUES (12);
INSERT INTO Cart (CartID) VALUES (13);
INSERT INTO Cart (CartID) VALUES (14);

-- EmpID 0 is the online order virtual employee
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (1,1,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (2,2,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (3,3,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (4,4,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (5,5,6,'2018-05-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (6,6,7,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (7,7,8,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (8,8,9,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (9,9,10,'2018-01-01 10:00:00.000000',9.99);
-- Anonymous Customers are all Customer 0
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (11,1,1,'2018-05-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (12,1,1,'2018-05-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (13,1,1,'2018-05-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (14,1,1,'2018-05-01 10:00:00.000000',9.99);


INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (1,1,1,1.1);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (1,1,2,2.21);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (1,2,2,1.2);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (2,2,2,2.2);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (3,3,3,1.3);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (4,4,4,1.4);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (5,5,5,1.5);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (6,6,6,1.6);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (7,7,7,1.7);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (8,8,8,1);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (9,9,9,1);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (10,10,10,1);


/*
       Items Query
SELECT Item.ItemCode, Item.InStock, Manufacturer.Manufacturer, Item.Description, Item.Price, Item.Weight, Measurement.Measurement
FROM Item INNER JOIN Measurement INNER JOIN Manufacturer
WHERE Item.ManufID = Manufacturer.ManufID && Item.MeasID = Measurement.MeasID && Item.ItemCode != 0000 ORDER BY Item.ItemCode;
*/