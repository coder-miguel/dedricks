DROP DATABASE   IF EXISTS     dedricks;
CREATE DATABASE IF NOT EXISTS dedricks;

use dedricks;

CREATE TABLE Picture (
    PictureID      smallint(4)   ZEROFILL NOT NULL,#Reflect ItemCode?
    Picture        blob                   NOT NULL,

	Primary Key(PictureID)
);

CREATE TABLE Unit(
	UnitID         tinyint(1)    ZEROFILL NOT NULL,#AUTO_INCREMENT later
	Unit           varchar(8)             NOT NULL,
       #Ea             boolean                NOT NULL,

	Primary Key(UnitID)
);

CREATE TABLE Brand(
	BrandID        smallint(4)   ZEROFILL NOT NULL,#AUTO_INCREMENT later
	Brand          varchar(32)            NOT NULL,

	Primary Key(BrandID)
);

CREATE TABLE Category (
	CatID          tinyint(2)    ZEROFILL,         #AUTO_INCREMENT later
	Category       varchar(16)            NOT NULL,

    Primary Key(CatID)
);

CREATE TABLE Item (
	ItemCode       smallint(4)   ZEROFILL NOT NULL,#AUTO_INCREMENT later
	InStock        smallint                   NULL DEFAULT    0,
	BrandID        smallint(4)   ZEROFILL     NULL,
        Description    varchar(64)            NOT NULL DEFAULT   '',
        Price          decimal(6,2)           NOT NULL DEFAULT    0,
        Weight         decimal(6,2)               NULL DEFAULT NULL,
        UnitID         tinyint(1)    ZEROFILL NOT NULL DEFAULT    1,
        EaYN           boolean                NOT NULL DEFAULT true,
        PictureID      smallint(4)   ZEROFILL     NULL,

    Foreign Key (BrandID)   References Brand(BrandID),
    Foreign Key (UnitID)    References Unit(UnitID),
    Foreign Key (PictureID) References Picture(PictureID),
    Primary Key (ItemCode),
    Unique Index ItemCode(BrandID, Description, Weight, UnitID)
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
	InfoID		smallint(10)	NOT NULL,
	FName		varchar(23)		NOT NULL,
	LName		varchar(23)		NULL,
	Phone		varchar(10)		NOT NULL,

	Primary Key(InfoID)
);


CREATE TABLE AddressBook_Optional(
	InfoID		smallint(10)	NOT NULL,
	Email		varchar(30)		NOT NULL,
	Password	varchar(25)		NULL,
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
	Wage_Salary boolean 		NOT NULL,
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
	SupOrderID 		int				NOT NULL,
	ItemCode 		smallint(4) 	ZEROFILL,
	DateReceived    datetime        NULL, 
	DateSellBy		datetime 		NULL,
	CostPerAmt		decimal(13,2)	NOT NULL,
	AmtSupplied 	int 			NOT NULL,
	AmtWasted		int 			NOT NULL,
	
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
	CustID			int 			NOT NULL,
	EmpID 			smallint 		NOT NULL,
	DateCustOrder   datetime 		NOT NULL,
	Subtotal		decimal(13,2)	NOT NULL,

	Foreign Key (CartID) 	References Cart(CartID),
	Foreign Key (CustID) 	References Customer(CustID),
	Foreign Key (EmpID) 	References Employee(EmpID)
);

-----------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Cart_Item
(
	CartID 			int				NOT NULL,
	ItemCode 		smallint(4)		ZEROFILL,
	AmtToSell		int 			NOT NULL,
	MeasQuantity    int 			DEFAULT 1,
	
	Primary Key	(CartID, ItemCode),
	Foreign Key (CartID) 	References Cart(CartID),
	Foreign Key (ItemCode) 	References Item(ItemCode)
);

#INSERT INTO Picture(PictureID, Picture) VALUES (00000, LOAD_FILE('C:/xampp/mysql/data/dedricks/kelifsm.png'));

INSERT INTO Unit(UnitID, Unit) VALUES (0, 'ea'     );
INSERT INTO Unit(UnitID, Unit) VALUES (1, 'lb.'    );
INSERT INTO Unit(UnitID, Unit) VALUES (2, 'oz.'    );
INSERT INTO Unit(UnitID, Unit) VALUES (3, 'fl. oz.');
INSERT INTO Unit(UnitID, Unit) VALUES (4, 'ml'     );
INSERT INTO Unit(UnitID, Unit) VALUES (5, 'L'      );
INSERT INTO Unit(UnitID, Unit) VALUES (6, 'pt'     );
INSERT INTO Unit(UnitID, Unit) VALUES (7, 'qt'     );
INSERT INTO Unit(UnitID, Unit) VALUES (8, 'gal'    );
INSERT INTO Unit(UnitID, Unit) VALUES (9, ''       );

INSERT INTO Brand(BrandID, Brand) VALUES (00, 'Home Blend'                  );
INSERT INTO Brand(BrandID, Brand) VALUES (01, 'Finger Lakes'                );
INSERT INTO Brand(BrandID, Brand) turer) VALUES (02, 'Dutch Valley'                );
INSERT INTO Brand(BrandID, Brand) VALUES (03, 'Bob\'s Red Mill'             );
INSERT INTO Brand(BrandID, Brand) VALUES (04, 'Gatherer\'s'                 );
INSERT INTO Brand(BrandID, Brand) VALUES (05, 'Nutty & Fruity'              );
INSERT INTO Brand(BrandID, Brand) VALUES (06, 'Harold Import Co.'           );
INSERT INTO Brand(BrandID, Brand) VALUES (07, 'Wheat Montana'               );
INSERT INTO Brand(BrandID, Brand) VALUES (08, 'Primitives by Kathy'         );
INSERT INTO Brand(BrandID, Brand) VALUES (09, 'Made in USA'                 );
INSERT INTO Brand(BrandID, Brand) VALUES (10, 'Darice Inc.'                 );
INSERT INTO Brand(BrandID, Brand) VALUES (11, 'Audrey\'s'                   );
INSERT INTO Brand(BrandID, Brand) VALUES (12, 'Golden Barrel'               );
INSERT INTO Brand(BrandID, Brand) VALUES (13, 'Wholesome'                   );
INSERT INTO Brand(BrandID, Brand) VALUES (14, 'Bragg'                       );
INSERT INTO Brand(BrandID, Brand) VALUES (15, 'Junket'                      );
INSERT INTO Brand(BrandID, Brand) VALUES (16, 'Lawrence Foods'              );
INSERT INTO Brand(BrandID, Brand) VALUES (17, 'Butlers'                     );
INSERT INTO Brand(BrandID, Brand) VALUES (18, 'Andes'                       );
INSERT INTO Brand(BrandID, Brand) VALUES (19, 'Superior Touch'              );
INSERT INTO Brand(BrandID, Brand) VALUES (20, 'Mayor Potencial'             );
INSERT INTO Brand(BrandID, Brand) VALUES (21, 'Ye Olde Goat Cart'           );
INSERT INTO Brand(BrandID, Brand) VALUES (22, 'Southeastern'                );
INSERT INTO Brand(BrandID, Brand) VALUES (23, 'Mrs. Millers'                );
INSERT INTO Brand(BrandID, Brand) VALUES (24, 'Sommers'                     );
INSERT INTO Brand(BrandID, Brand) VALUES (25, 'Trinity Valley'              );
INSERT INTO Brand(BrandID, Brand) VALUES (26, 'Boylan'                      );
INSERT INTO Brand(BrandID, Brand) VALUES (27, 'Beak & Skiff Apple Orchards' );
INSERT INTO Brand(BrandID, Brand) VALUES (28, '1000 Island\'s'              );
INSERT INTO Brand(BrandID, Brand) VALUES (29, 'Simply Supreme'              );
INSERT INTO Brand(BrandID, Brand) VALUES (30, 'Downey\'s'                   );
INSERT INTO Brand(BrandID, Brand) VALUES (31, 'Cabot'                       );
INSERT INTO Brand(BrandID, Brand) VALUES (32, 'Edwards'                     );
INSERT INTO Brand(BrandID, Brand) VALUES (33, 'Cooper Hill Maple'           );
INSERT INTO Brand(BrandID, Brand) VALUES (34, 'A & L Farm Market'           );
INSERT INTO Brand(BrandID, Brand) VALUES (35, 'Dare'                        );
INSERT INTO Brand(BrandID, Brand) VALUES (36, 'Boghosian'                   );
INSERT INTO Brand(BrandID, Brand) VALUES (37, 'Zimmerman\'s'                );
INSERT INTO Brand(BrandID, Brand) VALUES (38, 'Jake & Amos'                 );
INSERT INTO Brand(BrandID, Brand) VALUES (39, 'Olivari'                     );
INSERT INTO Brand(BrandID, Brand) VALUES (40, 'Miss Linda\'s Baked Goods'   );
INSERT INTO Brand(BrandID, Brand) VALUES (41, 'Wild Garden'                 );
INSERT INTO Brand(BrandID, Brand) VALUES (42, 'Unique'                      );
INSERT INTO Brand(BrandID, Brand) VALUES (43, 'Blue Diamond'                );
INSERT INTO Brand(BrandID, Brand) VALUES (44, 'Gillium Candy Company'       );
INSERT INTO Brand(BrandID, Brand) VALUES (45, 'Tropical Green Organics'     );
INSERT INTO Brand(BrandID, Brand) VALUES (46, 'New Hope Mills'              );
INSERT INTO Brand(BrandID, Brand) VALUES (47, 'Crunchmaster'                );
INSERT INTO Brand(BrandID, Brand) VALUES (48, 'Argueta\'s'                  );

INSERT INTO Category(CatID, Category) VALUES (00, '0.Admin'        );
INSERT INTO Category(CatID, Category) VALUES (01, 'Bakery'         );
INSERT INTO Category(CatID, Category) VALUES (02, 'Beverage'       );
INSERT INTO Category(CatID, Category) VALUES (03, 'Cereal'         );
INSERT INTO Category(CatID, Category) VALUES (04, 'Coffee/Tea'     );
INSERT INTO Category(CatID, Category) VALUES (05, 'Dairy'          );
INSERT INTO Category(CatID, Category) VALUES (06, 'General'        );
INSERT INTO Category(CatID, Category) VALUES (07, 'Meat'           );
INSERT INTO Category(CatID, Category) VALUES (08, 'Non-Perishable' );
INSERT INTO Category(CatID, Category) VALUES (09, 'Nuts/Seeds'     );
INSERT INTO Category(CatID, Category) VALUES (10, 'Oil/Vinegar'    );
INSERT INTO Category(CatID, Category) VALUES (11, 'Organic'        );
INSERT INTO Category(CatID, Category) VALUES (12, 'Pasta/Noodles'  );
INSERT INTO Category(CatID, Category) VALUES (13, 'Produce'        );
INSERT INTO Category(CatID, Category) VALUES (14, 'Snack'          );
INSERT INTO Category(CatID, Category) VALUES (15, 'Special'        );
INSERT INTO Category(CatID, Category) VALUES (16, 'Spice/Herb'     );
INSERT INTO Category(CatID, Category) VALUES (17, 'Sweets'         );
                                                                                                        # code    qty  description                                                               price  weight meas  manuf pic    ea?
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0001,    0, 'Chai Tea',                                                                4.23,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0002,    0, 'Hazelnut Cappuccino',                                                     3.72,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0003,    0, 'Cinnamon Vanilla Nut Cappuccino',                                         5.58,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0004,    0, 'Chocolate Raspberry Cappuccino',                                          5.58,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0005,    0, 'French Vanilla Cappuccino',                                               3.72,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0006,    0, 'Swiss Mocha Cappuccino',                                                  3.72,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0007,    0, 'Dark Hot Chocolate Mix',                                                  4.47,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0008,    0, 'Jamaican Me Crazy',                                                        8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0009,    0, 'Dark Guatemala',                                                           8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0010,    0, 'Guatemala Juan Anna Toliman',                                              8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0011,    0, 'Witches Brew',                                                             8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0012,    0, 'Nutty Buddy',                                                              8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0013,    0, 'Skaneateles Blend',                                                        8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0014,    0, 'Canandaigua Blend',                                                        8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0015,    0, 'Chocolate Raspberry ',                                                     8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0016,    0, 'Jamaican Me Crazy',                                                        8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0017,    0, 'Dark Guatemala',                                                           8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0018,    0, 'Skaneateles Blend',                                                        8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0019,    0, 'Canandaigua Blend',                                                        8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0020,    0, 'Finger Lakes Decaf',                                                       8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0021,    0, 'Nutty Buddy',                                                              6.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0022,    0, 'Witches Brew',                                                             8.0,  NULL,   0,    01,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0023,    0, 'Yogurt Coated Raisins',                                                   3.85,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0024,    0, 'Yogurt Coated Almonds',                                                   5.96,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0025,    0, 'Currants with Oil',                                                       2.91,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0026,    0, 'Black Corinthian Currants',                                               2.26,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0027,    0, 'Natural Wild Blueberry Oatmeal',                                          4.12,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0028,    0, 'Spearmint Leaves',                                                        1.99,  15.0,   2,    02,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0029,    0, 'Mini Peppermint Puffs',                                                   5.49,  15.0,   2,    02,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0030,    0, 'Natural Cinnamon Apple Oatmeal',                                          4.08,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0031,    0, 'White Pepper Ground',                                                    30.16,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0032,    0, 'Wintergreen Lozenges',                                                    1.99,  12.0,   2,    02,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0033,    0, 'English Breakfast Bulk Tea',                                              18.0,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0034,    0, 'Raspberry Bulk Tea',                                                     20.09,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0035,    0, 'Chamomile Bulk Tea',                                                     18.26,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0036,    0, 'Christmas Tree Drizzle Pretzel',                                          4.44,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0037,    0, 'Roasted & Salted Soybeans',                                               5.87,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0038,    0, 'Black Licorice Wheels',                                                    4.2,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0039,    0, 'Gluten Free Oatmeal Blueberry and Hazelnut',                              2.49,   2.5,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0040,    0, 'Gourmet Granola',                                                         7.39,   9.0,   2,    04,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0041,    0, 'Sliced Banana',                                                           4.79,   7.0,   2,    05,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0042,    0, 'Mesh Wonder Ball',                                                        3.99,  NULL,   0,    06,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0043,    0, 'Coconut Oolong Bulk Tea',                                                 31.0,   1.0,   1,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0044,    0, 'Peppermint Bulk Tea',                                                     18.0,   1.0,   1,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0045,    0, 'Hard Red Spring Wheat',                                                   4.72,   5.0,   1,    07,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0046,    0, 'Magnetic List Notepad',                                                   2.99,  NULL,   0,    08,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0047,    0, 'Magnetic Pad and Pencil',                                                 5.49,  NULL,   0,    09,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0048,    0, 'Small Notebook Set',                                                      3.99,  NULL,   0,    08,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0049,    0, 'Canvas Notebook',                                                        12.49,  NULL,   0,    08,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0050,    0, 'Memo Pad',                                                                2.99,  NULL,   0,    10,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0051,    0, '24in Hanging Sign',                                                      15.99,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0052,    0, 'Family',                                                                  3.99,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0053,    0, 'Box Sign',                                                               12.99,  NULL,   0,    08,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0054,    0, 'Heart Shaped Matthew 5:14 Sign',                                          9.99,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0055,    0, 'Stick Pencil',                                                            1.99,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0056,    0, 'Cloth with Writing',                                                      5.99,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0057,    0, 'Farm Fresh Vintage Tray',                                                26.99,  NULL,   0,    11,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0058,    0, 'Message Blocks',                                                          5.59,  NULL,   0,    11,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0059,    0, 'Unsulfured Blackstrap Molasses',                                         10.64,   1.0,   8,    12,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0060,    0, 'Unsulfured Blackstrap Molasses',                                          4.99,   1.0,   7,    12,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0061,    0, 'Organic Blue Agave',                                                      6.32,  NULL,   0,    13,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0062,    0, 'Organic Raw Blue Agave',                                                  6.32,  NULL,   0,    13,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0063,    0, 'Unfiltered Apple Cider Vinegar',                                          4.05,  NULL,   0,    14,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0064,    0, 'Xanthan Gum',                                                             20.6,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0065,    0, 'Dutch Jell? Natural Pectin Mix',                                          6.92,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0066,    0, 'Danish Dessert',                                                          1.89,  NULL,   0,    15,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0067,    0, 'Lemon Gelatin',                                                           3.46,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0068,    0, 'Raspberry Gelatin',                                                       3.46,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0069,    0, 'Natural Unflavored Gelatin',                                             12.65,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0070,    0, 'Strawberry EZ Squeeze Filling',                                           4.75,  NULL,   0,    16,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0071,    0, 'Bavarian Cream',                                                          4.75,  NULL,   0,    02,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0072,    0, 'Gourmet Semi-Sweet Chocolate Drops',                                      3.75,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0073,    0, 'Food Colors',                                                             2.89,  NULL,   0,    17,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0074,    0, 'Artificial Coconut Flavor',                                                3.0,  NULL,   0,    17,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0075,    0, 'Double Strength Clear imitation Vanilla',                                 4.65,  NULL,   0,    17,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0076,    0, 'Pure Vanilla Extract',                                                   33.94,  NULL,   0,    17,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0077,    0, 'Raspberry EZ Squeeze Filling',                                            4.75,  NULL,   0,    16,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0078,    0, 'Apple EZ Squeeze Filling',                                                 4.0,  NULL,   0,    16,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0079,    0, 'White Diamond Crystalz',                                                  7.02,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0080,    0, 'Silver Crystalz',                                                         7.02,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0081,    0, 'Emerald Green Crystalz',                                                  7.02,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0082,    0, 'Gold Crystalz',                                                           7.02,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0083,    0, 'Sapphire Blue Crystalz',                                                  7.02,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0084,    0, 'Ruby Red Crystalz',                                                       7.02,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0085,    0, 'Chocolate Sprinkles',                                                     5.25,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0086,    0, 'Alum Powder(Food Grade)',                                                 2.96,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0087,    0, 'Granulated Lemon Citrus Peel',                                            24.0,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0088,    0, 'Crème De Menthe Baking Chips',                                            4.39,  NULL,   0,    18,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0089,    0, 'Natural Cocoa Powder 10/12',                                              4.61,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0090,    0, 'Black Cocoa Powder 10/12',                                                4.12,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0091,    0, 'Dutch Cocoa Powder 10/12',                                                5.72,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0092,    0, 'Light Green Sprinkles',                                                   4.39,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0093,    0, 'Gingerbread Men Shapes',                                                  8.42,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0094,    0, 'Pink Sanding Sugar',                                                      5.36,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0095,    0, 'Pastel Yellow Sanding Sugar',                                             5.08,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0096,    0, 'Red Sanding Sugar',                                                       5.33,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0097,    0, 'Green Gourmet Sugar',                                                     5.52,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0098,    0, 'Granulated Orange Citrus Peel',                                          11.94,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0099,    0, 'Couscous with Chives and Saffron',                                        4.64,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0100,    0, 'Organic Gluten Free Tri-Color Quinoa',                                    7.44,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0101,    0, 'Quinoa',                                                                  3.95,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0102,    0, 'Couscous(Whole Wheat)',                                                   2.06,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0103,    0, 'Medium Couscous',                                                          1.9,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0104,    0, 'Big Star Decoration',                                                    15.99,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0105,    0, 'Long Grain Brown Rice 4%',                                                 1.2,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0106,    0, 'Black Thai Rice(Purple Sticky)',                                          5.92,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0107,    0, 'Red Rice',                                                                3.75,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0108,    0, 'Brown Basmati Rice',                                                      4.53,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0109,    0, 'Natural Northern Wild Rice',                                             14.14,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0110,    0, 'Non GMO Natural White Jasmine Rice',                                       1.7,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0111,    0, 'Ham Base',                                                                5.49,  NULL,   0,    19,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0112,    0, 'Medium Grain White Rice',                                                 1.11,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0113,    0, 'Long Grain White Rice 4%',                                                0.94,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0114,    0, 'Roasted Beef Base',                                                       5.49,  NULL,   0,    19,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0115,    0, 'Roasted Chicken Base',                                                    5.49,  NULL,   0,    19,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0116,    0, 'Seasoned Vegetable Base',                                                 5.49,  NULL,   0,    19,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0117,    0, 'Chicken Bouillon Cubes',                                                 10.74,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0118,    0, 'Beef Bouillion Cubes',                                                   10.74,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0119,    0, 'Vegetable Bouillon Cubes',                                               10.74,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0120,    0, 'Lufa',                                                                    4.99,  NULL,   0,    20,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0121,    0, 'GrapeFruit Candle',                                                       21.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0122,    0, 'Coasters',                                                                8.99,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0123,    0, 'Reduced Sodium Chicken Broth Mix',                                        5.46,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0124,    0, 'Greeting Card',                                                           6.49,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0125,    0, 'Salted Caramel Candle Medium-Small',                                       8.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0126,    0, 'Mango Peach Preserves Medium',                                            14.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0127,    0, 'Salted Caramel Candle Small',                                              6.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0128,    0, 'Mango Peach Preserves Large',                                             21.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0129,    0, 'Hazelnut Candle Medium-Small',                                             8.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0130,    0, 'Beard Oil Unscented',                                                     15.0,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0131,    0, 'Chapstick orange',                                                         2.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0132,    0, 'Hazelnut Candle Medium',                                                  14.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0133,    0, 'Harvest Candle Medium-Small',                                              8.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0134,    0, 'Harvest Candle Small',                                                     6.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0135,    0, 'Hazelnut Candle Large',                                                   21.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0136,    0, 'Gingerbread Candle Small',                                                 6.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0137,    0, 'Gingerbread Candle Large',                                                21.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0138,    0, 'Farmers Market Candle Small',                                              6.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0139,    0, 'Farmers Market Candle Medium-Small',                                       8.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0140,    0, 'Gingerbread Candle Medium-Small',                                          8.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0141,    0, 'Gingerbread Candle Medium',                                               14.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0142,    0, 'Farmers Market Candle Medium',                                            14.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0143,    0, 'Farmers Market Candle Large',                                             21.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0144,    0, 'Farmhouse Cider Candle Medium-Small',                                      8.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0145,    0, 'Cranberry Chutney Candle Small',                                           6.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0146,    0, 'Cranberry Chutney Candle Medium',                                         14.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0147,    0, 'Farmhouse Cider Candle Large',                                            21.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0148,    0, 'Cinnamon and Spice Candle Medium-Small',                                   8.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0149,    0, 'Cinnamon and Spice Candle Medium',                                        14.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0150,    0, 'Cinnamon and Spice Candle Large',                                         21.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0151,    0, 'Buttery Maple Syrup Medium',                                              14.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0152,    0, 'Buttery Maple Syrup Medium-Small',                                         8.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0153,    0, 'Buttery Maple Syrup Large',                                               21.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0154,    0, 'Roast Beef Gravy Mix',                                                    1.72,  NULL,   0,    22,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0155,    0, 'Country Gravy Mix',                                                       1.72,  NULL,   0,    22,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0156,    0, 'Roast Turkey Gravy Mix',                                                  1.64,  NULL,   0,    22,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0157,    0, 'Roast Chicken Gravy Mix',                                                 1.75,  NULL,   0,    22,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0158,    0, 'Cranberry Chutney Candle Large',                                          21.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0159,    0, 'Buttered Maple Espresso Candle Large',                                    21.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0160,    0, 'Buttered Maple Espresso Candle Medium',                                   14.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0161,    0, 'Blueberry Cobbler Candle Small',                                           6.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0162,    0, 'Blueberry Cobbler Candle Medium-Small',                                    8.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0163,    0, 'Blueberry Cobbler Candle Large',                                          21.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0164,    0, 'O\' Christmas Tree Candle Small',                                          6.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0165,    0, 'O\' Christmas Tree Candle Medium',                                        14.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0166,    0, 'Lantern Decorative',                                                     23.99,  NULL,   0,    11,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0167,    0, 'Kiss me Goodnight Sign',                                                 10.49,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0168,    0, 'Hatch America',                                                           25.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0169,    0, 'Lemon-Pepper Noodles',                                                    3.25,  NULL,   0,    23,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0170,    0, '16 Spray-Dk must/Autumn/Brown',                                           2.99,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0171,    0, 'Spinach Noodles',                                                         3.25,  NULL,   0,    23,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0172,    0, 'Pesto Noodles',                                                           3.25,  NULL,   0,    23,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0173,    0, 'Tomato-Basil Noodles',                                                    3.25,  NULL,   0,    23,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0174,    0, 'Broccoli-Carrot Noodles',                                                 3.23,  NULL,   0,    23,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0175,    0, 'Artichoke-Spinach Noodles',                                               3.25,  NULL,   0,    23,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0176,    0, 'Homestyle Egg Noodles',                                                   5.65,  NULL,   0,    24,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0177,    0, 'Old Fashioned Kluski Noodles',                                            3.14,  NULL,   0,    23,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0178,    0, 'Old Fashioned Angel Hair Noodles',                                        3.25,  NULL,   0,    23,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0179,    0, 'Porcini Mushroom Egg Noodles',                                            5.65,  NULL,   0,    24,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0180,    0, 'Egg White Wide Noodles',                                                  3.14,  NULL,   0,    23,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0181,    0, 'Old Fashiond Wide Noodles',                                               3.14,  NULL,   0,    23,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0182,    0, 'Medium Egg Noodles',                                                      2.27,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0183,    0, 'Lemongrass Soap Container',                                                7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0184,    0, 'Lavender Soap Container',                                                  7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0185,    0, 'Rosemary and Peppermint Soap Container',                                   7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0186,    0, 'Fresh Orange Soap Bar',                                                    7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0187,    0, 'Patchouli Soap Bar',                                                       7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0188,    0, 'Eucalyuptus Soap Bar',                                                     7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0189,    0, 'Cucumber Melon Soap Bar',                                                  7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0190,    0, 'Lemongrass Soap Bar',                                                      7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0191,    0, 'Billy Goats Gruff Soap Bar',                                               8.0,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0192,    0, 'Lavender Soap Bar',                                                        7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0193,    0, 'Patriotic Wildberry Soap Bar',                                             7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0194,    0, 'Tea Tree Soap Bar',                                                        7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0195,    0, 'RoseMary and Peppermint Soap Bar',                                         7.5,  NULL,   0,    21,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0196,    0, 'Black Chia Seeds',                                                        7.82,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0197,    0, 'Chili Powder',                                                           11.72,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0198,    0, 'Chive Rings',                                                              1.0,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0199,    0, 'Cilantro',                                                               18.33,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0200,    0, 'Ceylon Ground Cinnamon',                                                 33.31,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0201,    0, 'Ground Cinnamon 1% Volatile Oil',                                         9.22,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0202,    0, 'Whole Cloves',                                                           23.91,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0203,    0, 'Ground Cloves',                                                          27.38,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0204,    0, 'Ground Allspice',                                                         13.5,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0205,    0, 'Allspice Whole',                                                         14.07,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0206,    0, 'Anise Seeds',                                                            12.47,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0207,    0, 'Basil Leaves',                                                            22.2,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0208,    0, 'Caraway Seeds Whole',                                                     7.72,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0209,    0, 'Celery Flakes',                                                          21.28,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0210,    0, 'Whole Celery Seeds',                                                      4.05,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0211,    0, 'Celery Salt',                                                             4.94,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0212,    0, 'Ground Nutmeg',                                                          26.17,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0213,    0, 'Natural Herbes De Provence',                                             13.87,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0214,    0, 'Italian Seasoning',                                                       7.92,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0215,    0, 'Marjoram Leaves',                                                         1.25,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0216,    0, 'Ground Mustard Seeds',                                                    6.93,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0217,    0, 'Mustard Seeds #1',                                                        7.04,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0218,    0, 'Garlic Powder',                                                          11.51,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0219,    0, 'Roasted Granulated Garlic',                                              25.55,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0220,    0, 'Garlic Salt',                                                             7.18,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0221,    0, 'Ground Ginger',                                                            9.5,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0222,    0, 'Ground Cumin',                                                            9.05,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0223,    0, 'Natural Curry Powder',                                                    8.29,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0224,    0, 'Dill Weed',                                                              25.34,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0225,    0, 'Whole Fennel Seed',                                                       8.18,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0226,    0, 'Whole Cortander',                                                         5.54,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0227,    0, 'Ground Cortander',                                                        6.78,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0228,    0, '3-inch Cinnamon Sticks',                                                 12.91,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0229,    0, 'Whole Nutmeg',                                                           29.33,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0230,    0, 'Minced Onion',                                                             9.7,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0231,    0, 'Onion Salt, No MSG Added',                                                6.04,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0232,    0, 'Oregano Ground',                                                          9.99,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0233,    0, 'Hungarian Paprika',                                                      10.34,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0234,    0, 'Smoked Paprika',                                                          12.0,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0235,    0, 'Medium Grind Black Pepper',                                              19.38,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0236,    0, 'Ground Red Pepper',                                                       8.01,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0237,    0, 'Crushed Red Pepper ',                                                     7.67,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0238,    0, 'Whole Black Peppercorns',                                                12.58,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0239,    0, 'Mixed Peppercorns',                                                      39.93,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0240,    0, 'Peppercorns White Whole',                                                27.55,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0241,    0, 'Poppy Seeds',                                                              9.3,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0242,    0, 'Whole Bay Leaves',                                                         2.0,  NULL,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0243,    0, 'Medium Himalayan Pink Salt',                                               5.5,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0244,    0, 'Fine Himalayan Pink Salt',                                                 5.5,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0245,    0, 'Ground Savory',                                                          13.13,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0246,    0, 'Ground Thyme',                                                           10.67,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0247,    0, 'Whole Thyme Leaves',                                                     15.93,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0248,    0, 'Ground Turmeric',                                                         8.42,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0249,    0, 'Pickling Spice',                                                          4.01,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0250,    0, 'Table Salt',                                                              0.47,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0251,    0, 'Uncle Larrys Natural Season Salt',                                        7.11,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0252,    0, 'Sea Salt (Food Grade)',                                                   1.01,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0253,    0, 'Real Salt',                                                               4.65,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0254,    0, 'Natural Cajun Seasoning, No MSG Added',                                  10.41,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0255,    0, 'Taco Seasoning',                                                          7.46,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0256,    0, 'Montana Natural Steak Seasoning',                                        12.22,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0257,    0, 'Natural Jamaican Jerk Seasoning',                                          8.9,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0258,    0, 'Natural Hickory Smoke Salt',                                              8.36,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0259,    0, 'Natural Lemon Pepper',                                                     9.1,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0260,    0, 'Chicken BBQ Poultery Seasoning',                                          36.0,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0261,    0, 'Ground Sage',                                                            16.42,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0262,    0, 'Whole Rosemary',                                                          5.99,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0263,    0, 'Rosemary Ground',                                                         6.83,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0264,    0, 'Natural Pumpkin Pie Spice',                                              12.29,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0265,    0, 'Wasabi Green Peas',                                                       6.85,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0266,    0, 'Seasoned Rye Bread Chips',                                                 6.3,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0267,    0, 'Garlic Bagel Chips',                                                      5.31,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0268,    0, 'Pecan Bowlby Bits',                                                       9.11,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0269,    0, 'Crisp Vegetable Chips',                                                   9.64,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0270,    0, 'Salted Corn Chips with Flax',                                             3.05,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0271,    0, 'Honey Mustard and Onion Sesame Sticks',                                   3.63,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0272,    0, 'Wide Sesame Sticks',                                                      3.51,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0273,    0, 'Deluxe Snak-ems Mix',                                                     6.38,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0274,    0, 'Everything Sesame Sticks',                                                3.54,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0275,    0, 'Oriental Rice',                                                           3.44,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0276,    0, 'Little Ones',                                                             2.84,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0277,    0, 'Reese\'s Peanut Butter Chips 4M',                                         5.28,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0278,    0, 'Cinnamon Drops',                                                          4.44,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0279,    0, 'Coconut Oil',                                                             6.36,  NULL,   0,    12,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0280,    0, 'Creamline Chocolate Milk',                                                1.39,  16.0,   3,    25,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0281,    0, 'Creamline Half & Half',                                                   2.07,  16.0,   3,    25,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0282,    0, 'Creamline Whole Milk',                                                    1.29,  16.0,   3,    25,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0283,    0, 'Black Cherry, Soda',                                                      1.59,  12.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0284,    0, 'Black Cherry, Soda (4-pack)',                                             4.99,  48.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0285,    0, 'Creamy Red Birch Beer, Soda',                                             1.59,  12.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0286,    0, 'Creamy Red Birch Beer, Soda (4-pack)',                                    4.99,  48.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0287,    0, 'Root Beer, Soda',                                                         1.59,  12.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0288,    0, 'Root Beer, Soda (4-pack)',                                                4.99,  48.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0289,    0, 'Grape, Soda',                                                             1.59,  12.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0290,    0, 'Grape, Soda (4-pack)',                                                    4.99,  48.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0291,    0, 'Orange, Soda',                                                            1.59,  12.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0292,    0, 'Orange, Soda (4-pack)',                                                   4.99,  48.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0293,    0, 'Creamline Chocolate Milk',                                                3.58,   0.5,   8,    25,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0294,    0, 'Creamline Chocolate Milk',                                                5.79,   1.0,   8,    25,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0295,    0, 'Cane Cola, Soda',                                                         1.59,  12.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0296,    0, 'Cane Cola, Soda (4-pack)',                                                4.99,  48.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0297,    0, 'Creme, Soda',                                                             1.59,  12.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0298,    0, 'Creme, Soda (4-pack)',                                                    4.99,  48.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0299,    0, 'Birch Beer, Soda',                                                        1.59,  12.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0300,    0, 'Birch Beer, Soda (4-pack)',                                               4.99,  48.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0301,    0, 'Ginger Ale, Soda',                                                        1.59,  12.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0302,    0, 'Ginger Ale, Soda (4-pack)',                                               4.99,  48.0,   3,    26,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0303,    0, 'Creamline Whole Milk',                                                    3.09,   0.5,   8,    25,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0304,    0, 'Creamline Whole Milk',                                                    4.96,   1.0,   8,    25,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0305,    0, 'Creamline Skim Milk',                                                     2.84,   0.5,   8,    25,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0306,    0, 'Apple Cider, Gluten Free',                                                1.99,  NULL,   0,    27,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0307,    0, 'Old Fashoned Chocolate Fudge',                                            9.66,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0308,    0, 'Sea Salted Caramel Fudge',                                                9.66,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0309,    0, 'Creamline 2% Reduced Fat Milk',                                           2.95,  64.0,   3,    25,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0310,    0, 'Apple Cider Vinegar All Natural Drink, Ginger Spice',                     2.79,  16.0,   3,    14,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0311,    0, 'Apple Cider Vinegar All Natural Drink, Apple Cider Vinegar & Honey',      2.79,  16.0,   3,    14,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0312,    0, 'Apple Cider Vinegar All Natural Drink, Concord Grape - Acai',             2.79,  16.0,   3,    14,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0313,    0, 'River Rat Cheese, Chunky Bleu Flavor',                                     4.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0314,    0, 'River Rat Cheese, Jalapeno',                                               4.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0315,    0, 'River Rat Cheese, Garden Vegetable',                                       4.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0316,    0, 'River Rat Cheese, Aged Asiago',                                            4.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0317,    0, 'River Rat Cheese, Sharp Cheddar',                                          4.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0318,    0, 'River Rat Cheese, Swiss & Almond',                                         4.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0319,    0, 'River Rat Cheese, Smokey Bacon Flavor',                                    4.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0320,    0, 'River Rat Cheese, Garlic & Herb',                                          4.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0322,    0, 'Hotsie Totsie Pepper Jack Cheese',                                         5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0323,    0, 'Wasabi Cheese NYS Cheddar',                                                5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0324,    0, '3 Year Old XXX Cheddar Cheese',                                            5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0325,    0, 'Sharp Chessar Cheese',                                                     5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0326,    0, 'Milk Cheddar Cheese',                                                      5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0327,    0, '8 Year Old Cheddar Cheese',                                                8.0,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0328,    0, 'Extra Sharp Cheddar Cheese',                                               5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0329,    0, 'Mean & Nasty Cheddar',                                                     6.2,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0330,    0, 'Maple Cheese NYS Cheddar',                                                 5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0331,    0, 'Date N\' Nut Roll',                                                       5.91,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0332,    0, 'Toasted Onion Cheese',                                                     5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0333,    0, 'Beer Kaese (Milk Limburger)',                                            10.99,   1.0,   1,    28,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0334,    0, 'Horseradish & Smoked Bacon Cheese',                                        5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0335,    0, 'Muenster Cheese',                                                          6.0,  10.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0336,    0, 'Jalapeno & Cayenne Pepper Cheese',                                         5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0337,    0, 'Pepperoni Cheese',                                                        9.99,   1.0,   1,    28,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0338,    0, 'Hot Buffalo Bill Cheese',                                                  5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0339,    0, 'Cheddaroni',                                                               5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0340,    0, 'Roasted Garlic Cheese',                                                    5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0341,    0, 'Hickory Smoked Cheese',                                                    5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0342,    0, 'Hot Horseradish River Rat Cheese',                                         5.5,   7.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0343,    0, 'Horseradish Cheese',                                                       5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0344,    0, 'Spicy Bacon Cheddar',                                                      5.5,   8.0,   2,    28,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0345,    0, 'Large Flake Nutritional Yeast',                                          14.95,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0346,    0, 'Large Medjool Dates',                                                     8.64,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0347,    0, 'Whole Fancy Pitted Dates',                                                4.06,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0348,    0, 'Chopped Dates with Oat Flour',                                             3.0,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0349,    0, 'Honey Mustard',                                                            3.3,  13.0,   2,    29,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0350,    0, 'Honey Butter, Cinnemon',                                                  3.79,   8.0,   2,    30,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0351,    0, 'Honey Butter, Original',                                                  3.79,   8.0,   2,    30,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0352,    0, 'Almond Paste',                                                           11.76,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0353,    0, 'Poppy Filling',                                                           5.21,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0354,    0, 'Natural Creamery Butter',                                                 3.69,   1.0,   1,    31,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0355,    0, 'Eggs, Dozen Grade A, Large',                                              1.99,  24.0,   2,    32,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0356,    0, 'Eggs, Dozen Grade A, Extra Large',                                        1.99,  27.0,   2,    32,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0357,    0, 'One Pound Granulated Maple Sugar',                                        18.2,   1.0,   1,    33,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0358,    0, 'Maple Syrup, Grade A Dark, Robust',                                       15.6, 500.0,   4,    33,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0359,    0, 'Maple Syrup, Grade A Dark, Robust',                                        6.5,  50.0,   4,    33,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0360,    0, 'Maple Syrup, Grade A Golden, Delicate',                                   10.5, 250.0,   4,    33,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0361,    0, 'Pure Honey, Fall Flower',                                                 20.0,   3.0,   1,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0362,    0, 'Pure Honey, Fall Flower',                                                 25.0,   5.0,   1,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0363,    0, 'Pure Honey, Bass Wood',                                                   10.0,   2.0,   1,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0364,    0, 'Pure Honey, Fall Flower',                                                  6.5,   1.0,   1,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0365,    0, 'Pure Honey, Buckwheat',                                                   6.25,   1.0,   1,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0366,    0, 'Pure Honey, Creamed Honey',                                               7.99,   1.0,   1,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0367,    0, 'Pure Maple Syrup, Grade A Dark, Robust, NY',                              9.25,  16.0,   3,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0368,    0, 'Pure Honey, Fall Flower',                                                  5.0,  12.0,   2,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0369,    0, 'Pure Maple Syrup, Grade A Amber, Rich, NY',                                4.0,   3.4,   3,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0370,    0, 'Pure Honey, Wild Flower',                                                  2.0,   2.0,   2,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0371,    0, 'Pure Honey, Bass Wood',                                                   7.99,   1.0,   1,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0372,    0, 'Pure Maple Syrup, Grade A Dark, Robust, NY',                              15.0,  32.0,   3,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0373,    0, 'Pure Maple Syrup, Grade A Amber, Rich, NY',                               28.0,  64.0,   3,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0374,    0, 'Pure Maple Syrup, Grade A Amber, Rich, NY',                               50.0, 128.0,   3,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0375,    0, 'Pure Maple Syrup, Grade A Amber, Rich, NY',                               52.0,   1.0,   8,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0376,    0, 'Pure Maple Syrup, Grade A Dark, Robust, NY',                              28.0,   0.5,   8,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0377,    0, 'Pure Maple Syrup, Grade A Golden, Delicate, NY',                          2.49,  40.0,   4,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0378,    0, 'Pure Maple Syrup, Grade A Golden, Delicate, NY',                          3.99,  30.0,   4,    34,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0379,    0, 'Hulled Raw Sesame Seeds',                                                 4.23,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0380,    0, 'Pine Nuts (Pignolias)',                                                  27.85,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0381,    0, 'Natural Roasted & Salted Pistachios 21/25',                              11.37,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0382,    0, 'Raw Pumpkin Seeds',                                                       6.19,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0383,    0, 'Roasted & Salted Sunflower Seeds in the Shell',                           1.42,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0384,    0, 'Roasted & Salted Sunflower Meats',                                        2.75,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0385,    0, 'Raw Sunflower Meats',                                                     2.67,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0386,    0, 'Brown Flaxseet Meal',                                                     2.21,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0387,    0, 'Brown Flaxseed',                                                          1.57,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0388,    0, 'Golden Flaxseed',                                                          2.2,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0389,    0, 'Dry Roasted Split Peanuts',                                               2.86,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0390,    0, 'Roasted & Salted Mixed Nuts with Peanuts',                                7.55,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0391,    0, 'Fancy Raw Cashew Pieces',                                                10.19,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0392,    0, 'Honey Toasted Cashews',                                                  14.69,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0393,    0, 'Roasted & Salted Extra Large Peanuts',                                    3.46,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0394,    0, 'Whole Blanched Medium Almonds',                                           7.53,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0395,    0, 'No Salt #1 Spanish Peanuts',                                              2.79,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0396,    0, 'Roasted & Salted Almonds 25/27',                                          8.46,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0397,    0, 'Mixed Nuts Whole',                                                        4.42,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0398,    0, 'Chocolate Raspberry Truffle Snack Mix',                                    7.4,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0399,    0, 'Wake Up Crunch Snack Mix',                                                5.65,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0400,    0, 'Raspberry Nut Supreme Snack Mix',                                         8.93,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0401,    0, 'Raw Walnut Halves and Pieces Combo',                                      5.81,   8.0,   2,    02,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0402,    0, 'Breton Original Bites',                                                   2.55,   8.0,   2,    35,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0403,    0, 'Breton Veggie Bites',                                                     2.55,   8.0,   2,    35,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0404,    0, 'Goji Berry Health Mix',                                                   7.51,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0405,    0, 'Nut-tritious Health Mix',                                                11.56,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0406,    0, 'Milk Chocolate Cashews',                                                  7.22,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0407,    0, 'Coffee & Cream Expresso Beans',                                           5.84,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0408,    0, 'Milk Chocolate Sunflower Seeds',                                          4.64,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0409,    0, 'Greek Yogurt Covered Pretzels',                                           4.61,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0410,    0, 'Chocolate Coated Pretzle Balls',                                          5.24,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0411,    0, 'Milk Chocolate Double Dipped peanuts',                                    6.41,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0412,    0, 'Red Chocolate Cherries',                                                 10.75,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0413,    0, 'Dark Chocolate Turbinado Almonds',                                        6.47,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0414,    0, 'Dark Chocolate Almonds',                                                  8.86,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0415,    0, 'Mini Dark Chocolate Peanut Butter Buckeyes',                              5.46,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0416,    0, 'Dark Chocolate Cashews',                                                   8.2,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0417,    0, 'Dark Chocolate Expresso Beans',                                           8.72,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0418,    0, 'Dark Chocolate Dried Cranberries',                                        6.01,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0419,    0, 'Dark Chocolate Cherries',                                                 8.49,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0420,    0, 'Mini Dark Chocolate Peanut Butter Cups',                                  5.46,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0421,    0, 'Dark Chocolate Malted Balls',                                             5.94,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0422,    0, 'Dark Chocolate Mini Pretzels',                                            5.05,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0423,    0, 'Dark Chocolate Ginger',                                                   6.01,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0424,    0, 'Mini Dark Chocolate Raspberry Cups',                                      4.98,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0425,    0, 'Dark Chocolate Raisins',                                                  5.05,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0426,    0, 'Dark Chocolate Pretzel Balls',                                            6.12,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0427,    0, 'Chocolate Pretzel Grahams',                                               4.87,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0428,    0, 'Boston Baked Beans',                                                      3.65,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0429,    0, 'Wasabi Peanut Crunchies',                                                 3.44,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0430,    0, 'Haviland Nonparells',                                                     5.25,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0431,    0, 'Melon Slices',                                                            3.89,   8.0,   2,    05,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0432,    0, '100% Natural Mango Slices',                                               5.55,   4.5,   2,    05,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0433,    0, 'Cantaloupe Soft Dry',                                                     4.76,   7.0,   2,    05,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0434,    0, 'Pineapple Rings 100% Natural',                                            4.76,   4.5,   2,    05,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0435,    0, 'Coconut Strips',                                                          3.89,   6.0,   2,    05,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0436,    0, 'Ladyfinger Popcorn',                                                      1.93,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0437,    0, 'Red Popcorn',                                                             1.17,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0438,    0, 'Brenon Original Crackers',                                                2.89,  NULL,   0,    35,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0439,    0, 'Dried Blueberries',                                                       9.65,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0440,    0, 'Tropical Fruit Trio',                                                     6.65,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0441,    0, 'Pineapple Tidbits',                                                       4.34,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0442,    0, 'Diced Turkish Apricots',                                                  3.59,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0443,    0, 'Raspberry Flavored Cranberry Pieces',                                     5.52,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0444,    0, 'Sweetened Banana Chips',                                                  2.58,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0445,    0, 'Dried Cranberries',                                                       3.69,  12.0,   2,    02,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0446,    0, 'Dried Sweet Cherries(Bing)',                                             11.87,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0447,    0, 'Medium White Popcorn',                                                    1.11,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0448,    0, 'Dried Tart Cherries',                                                     9.28,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0449,    0, 'Mango Slices',                                                            5.22,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0450,    0, 'California Sun Dried Rasins',                                             2.32,  15.0,   2,    36,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0451,    0, 'Crystallized Ginger Slices',                                              5.71,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0452,    0, 'Goji Berries',                                                           15.16,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0453,    0, 'Turkish Apricots',                                                        4.35,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0454,    0, 'Natural Creamy Peanut Butter',                                            4.19,  15.0,   2,    37,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0455,    0, 'Peacan Pumpkin Butter',                                                   2.99,   9.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0456,    0, 'Peach Jam',                                                               3.79,   9.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0457,    0, 'Natural Creamy Peanut Butter',                                            8.19,  32.0,   2,    37,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0458,    0, 'Strawberry Rhubarb Butter',                                               3.69,   9.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0459,    0, 'Peach Butter',                                                            3.59,   9.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0460,    0, 'Apple Butter',                                                            3.09,   9.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0461,    0, 'Red Raspberry Jam',                                                       3.09,   9.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0462,    0, 'Elderberry Jelly',                                                        3.99,   9.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0463,    0, 'Strawberry Jam',                                                          3.19,   9.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0464,    0, 'Medium Salsa',                                                            3.59,  14.5,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0465,    0, 'Corn Salsa',                                                              3.59,  14.5,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0466,    0, 'Milk Salsa',                                                              3.59,  14.5,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0467,    0, 'Hot Salsa',                                                               3.59,  14.5,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0468,    0, 'Whole Baby Dill Pickles',                                                 6.39,  32.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0469,    0, 'Pickled Baby Beets',                                                      4.89,  15.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0470,    0, 'Garlic & Jalapen Stuffed Olives',                                         5.59,   8.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0471,    0, 'Dill Pickle Spears',                                                      4.79,  15.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0472,    0, 'Lime Pickles',                                                            5.09,  16.0,   3,    38,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0473,    0, 'Bread & Butter Pickles',                                                  4.79,  15.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0474,    0, 'Pickled Snap Peas',                                                       5.19,  16.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0475,    0, 'Hot Pickled Mushrooms',                                                   6.09,  12.5,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0476,    0, 'Sweet Pickled Garlic',                                                    6.59,  16.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0477,    0, 'Sauerkraut',                                                              4.69,  16.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0478,    0, 'Sweet Garlic Dill Pickles',                                               4.59,  15.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0479,    0, 'Sweet Pickled Gherkins',                                                  4.59,  15.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0480,    0, 'Pickled Dilly Beans',                                                     4.59,  15.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0481,    0, 'Pickled Dilly Corn',                                                      4.59,  15.0,   2,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0482,    0, 'Garden Vegetable Soup, no MSG Added',                                     6.64,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0483,    0, 'Natural Harvest Soup Mix, no MSG Added',                                  3.72,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0484,    0, 'Black Turtle Beans',                                                      1.44,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0485,    0, 'Garbanzo Beans',                                                          2.49,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0486,    0, 'French Onion Soup Mix',                                                   6.86,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0487,    0, 'Yellow Split Peas',                                                        1.6,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0488,    0, 'Hearty Soup Mix',                                                         2.69,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0489,    0, 'Natural Holiday Soup Mix',                                                2.17,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0490,    0, 'Chunky Potato Soup Mix',                                                  3.91,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0491,    0, 'Green Split Peas',                                                        3.42,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0492,    0, 'Natual 13 Bean Soup Mix',                                                 2.93,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0493,    0, 'Navy Beans',                                                              1.78,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0494,    0, 'Food Grade Millet',                                                       0.67,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0495,    0, 'Pearled Barley',                                                          1.51,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0496,    0, 'Lentils',                                                                 2.27,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0497,    0, 'Pinto Beans',                                                             1.11,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0498,    0, 'White Distilled Vinegar, 4%',                                             3.99, 128.0,   3,    39,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0499,    0, 'Oatmeal Bread, Homemade',                                                 2.99,  NULL,   0,    40,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0500,    0, 'Multigrain, Homemade Bread',                                              3.29,  NULL,   0,    40,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0501,    0, 'Honey Wheat, Homemade Bread',                                             2.99,  NULL,   0,    40,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0502,    0, 'Chocolate Chocolate Chip Cookies',                                        1.29,   2.0,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0503,    0, 'Ginger Softs, Cookies',                                                   1.29,   2.0,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0504,    0, 'Chocolate Chip Cookies',                                                  1.29,   2.0,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0505,    0, 'Farm Style Oatmeal, Cookies',                                             1.29,   2.0,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0506,    0, 'Pumpkin Chocolate Chip, Cookies',                                         1.29,   2.0,   0,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0507,    0, 'White Bread, Homemade',                                                   2.99,  NULL,   0,    40,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0508,    0, 'Hummus Dip',                                                              2.99,  NULL,   0,    41,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0509,    0, 'Fall Leaf Shapes',                                                        8.93,  NULL,   0,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0510,    0, 'Autumn Sprinkles',                                                        6.29,  NULL,   0,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0511,    0, 'Pretzel Shells, Original',                                                2.49,  10.0,   2,    42,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0512,    0, 'Nut-Thins, Almond',                                                       3.69,  4.25,   2,    43,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0513,    0, 'Honey Lemon Menthol Cough Drops',                                         4.48,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0514,    0, 'Sanded Cinnamon Drops',                                                   2.25,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0515,    0, 'Anise Balls',                                                             2.45,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0516,    0, 'Deluxe Candy Mix',                                                        2.55,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0517,    0, 'Mini Tootsie Roll Midgees',                                               4.09,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0518,    0, 'Sesame Crunch',                                                           5.19,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0519,    0, 'Stick Candy',                                                             0.37,   0.5,   2,    44,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0520,    0, 'White Mint Lozenges',                                                     4.38,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0521,    0, 'Clove Balls',                                                             2.74,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0522,    0, 'Sanded Sassafras Drops',                                                  2.25,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0523,    0, 'Light Green Spearmint Lozenges',                                          2.61,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0524,    0, 'Atomic Fireball',                                                         1.68,   8.0,   2,    02,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0525,    0, 'Spearmint Starlites',                                                     3.16,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0526,    0, 'Sugar Free IBC Root Beer Floats',                                          6.6,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0527,    0, 'Assorted Jelly Beans',                                                    2.42,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0528,    0, 'Sugar Free Butterscotch Candy',                                           7.91,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0529,    0, 'Sugar Free Cinnamon Candy',                                               8.47,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0530,    0, 'Root Beer Barrels',                                                       3.37,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0531,    0, 'Gummi Chicken Feet',                                                       4.7,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0532,    0, 'Gummi Peach Rings',                                                       2.53,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0533,    0, 'Gummi Bear Cubs',                                                         4.51,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0534,    0, 'Candy Blox',                                                              5.35,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0535,    0, 'Mini Red Swedish Fish',                                                   4.38,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0536,    0, 'Candy Corn',                                                               2.6,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0537,    0, 'Peanut Brittle',                                                          3.03,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0538,    0, 'Raspberry Whole Wheat Fig Bars',                                          5.14,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0539,    0, 'Honey Process Coffee',                                                    11.5,   8.0,   2,    48,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0540,    0, 'Mayan Warrior Blend',                                                     12.0,  12.0,   2,    48,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0541,    0, '435 deg Medium Dark Roast',                                               12.0,  12.0,   2,    48,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0542,    0, '425 deg Medium Roast',                                                    12.0,  12.0,   2,    48,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0543,    0, '415 deg Light Medium Roast',                                              12.0,  12.0,   2,    48,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0544,    0, 'Licorice Rockies',                                                        6.17,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0545,    0, 'Cherry Slices',                                                           2.14,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0546,    0, 'Strawberry Licorice Wheels',                                              4.17,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0547,    0, 'Red and Black Berries',                                                   3.75,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0548,    0, 'Caramel Creams',                                                          3.79,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0549,    0, 'Spearmint Leaves',                                                        2.35,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0550,    0, 'Orange Slices',                                                           2.14,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0551,    0, 'Natural Strawberry Dip Mix, No MSG Added',                                6.79,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0552,    0, 'Natural Black Raspberry Dip Mix, No MSG Added',                           7.06,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0553,    0, 'Natural Caramel Apple Dip & Dessert Mix, No MSG Added',                   5.77,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0554,    0, 'Australian Style Black Licorice',                                         5.12,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0555,    0, 'Pumpkin?',                                                               24.69,   1.0,   1,    00,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0556,    0, 'Smooth \'N Melty Petite Mints',                                           6.81,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0557,    0, 'Box Sign Toilet Paper',                                                   9.99,  NULL,   0,    08,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0558,    0, 'Nesting Tins, We Gather Here With Thankful Hearts',                      24.99,  NULL,   0,    11,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0559,    0, 'String Box Sign - Pumpkin',                                               9.99,  NULL,   0,    08,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0560,    0, 'Travel Mug',                                                              9.99,  NULL,   0,    11,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0561,    0, 'Domino Dark Brown Sugar',                                                  1.3,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0562,    0, 'Light Brown Sugar',                                                       1.34,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0563,    0, 'Domino 10X Sugar',                                                        1.27,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0564,    0, 'American Beauty Hi-Rise-Cake Flour',                                      0.39,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0565,    0, 'Sir Lancelot Hi-Gluten Flour',                                            0.56,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0566,    0, 'Unbleached Occident Flour',                                               0.95,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0567,    0, 'Fine Yellow Cornmeal',                                                    0.69,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0568,    0, 'Medium Rye Meal Pumpernickle Flour',                                      1.04,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0569,    0, 'GM All Trumps Flour',                                                     0.92,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0570,    0, 'King Arthur Special Flour',                                               0.85,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0571,    0, 'Pie and Pastery Flour',                                                   0.71,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0572,    0, 'H&R Self-Rising Flour',                                                   0.65,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0573,    0, 'Ultragrain White Whole Wheat Flour',                                      0.78,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0574,    0, 'Whole Wheat Pire and Pastry Flour',                                       0.63,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0575,    0, 'Hulled Barley Flakes',                                                    0.92,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0576,    0, 'Steel Cut Oat Groats',                                                     1.0,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0577,    0, 'Rolled and Flaked 7-Grain Mix with Flax',                                 1.92,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0578,    0, 'Thick Rolled Oats #3',                                                    0.95,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0579,    0, 'Medium Rolled Oats #4',                                                   1.02,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0580,    0, 'Baker\'s Bran (Wheat)',                                                   0.62,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0581,    0, 'Quick Oats',                                                              0.93,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0582,    0, 'Baby Flake Oats',                                                         1.58,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0583,    0, 'Whole Oat Groats',                                                        0.99,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0584,    0, 'Oat Bran',                                                                0.97,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0585,    0, 'Cracked 9-Grain Mix',                                                     2.32,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0586,    0, 'Gluten Free All Purpose Flour',                                           3.17,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0587,    0, 'All Purpose Organic Flour, Unbleached White',                              9.4,   5.0,   1,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0588,    0, 'Whole Wheat Organic Flour, 100% Stone Ground',                            6.05,   3.0,   1,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0589,    0, 'Coarse Cracked Wheat',                                                    0.77,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0590,    0, 'Gluten Free Brown Rice Flour',                                            1.73,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0591,    0, 'Semolina Flour',                                                          1.35,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0592,    0, 'Dark Rye Flour',                                                           1.1,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0593,    0, 'Gluten Free Blanched Almond Meal/Flour',                                  10.9,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0594,    0, 'Organic Coconut Flour',                                                   2.83,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0595,    0, 'Gluten Free White Rice Flour',                                            1.65,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0596,    0, 'Premium 100% Whole Wheat Flour',                                           9.0,  10.0,   1,    07,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0597,    0, 'Xylitol',                                                                 7.78,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0598,    0, 'White Hominy Grits',                                                      1.24,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0599,    0, 'Very Berry Anti-Ox Muesli',                                               5.54,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0600,    0, 'Premium 100% Whole Wheat Flour',                                          6.44,   5.0,   1,    07,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0601,    0, 'Natural Swiss-Style Muesli',                                              4.19,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0602,    0, 'Demerara Unrefined Sugar',                                                1.13,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0603,    0, 'Organic Coconut Palm Sugar',                                              3.99,   1.0,   1,    45,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0604,    0, 'Garbanzo Bean Flour',                                                     2.94,   1.0,   1,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0605,    0, 'Potato Starch',                                                            4.7,   1.0,   1,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0606,    0, 'Wheat Germ',                                                              2.84,  0.12,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0607,    0, 'Old Fashioned Buckwheat Pancake Mix',                                     8.39,   5.0,   1,    46,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0608,    0, 'Old Fashioned Roled Oats, Wheat Free, Gluten Free, Dairy Free',           7.95,  32.0,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0609,    0, '10 Grain Hot Cereal',                                                     4.46,  25.0,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0610,    0, 'Buckwheat Flour, Whole Grain',                                            5.17,  22.0,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0611,    0, 'Brown Rice Flour, Whole Grain',                                            4.0,  24.0,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0612,    0, 'Barley Flour, Stone Ground',                                              3.15,  20.0,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0613,    0, 'Spelt Flour, Whole Grain, Stone Ground',                                   4.7,  24.0,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0614,    0, 'Tapioca Flour, Finely Ground',                                            4.29,  NULL,   0,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0615,    0, 'Vital Wheat Gluten',                                                      3.44,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0616,    0, 'Shortbreak Cookie Mix, Wheat Free, Gluten Free, Dairy Free',              4.29,  21.0,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0617,    0, 'Complete Restaurant Style Pancake Mix',                                   3.29,  32.0,   2,    46,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0618,    0, 'Rye Berries',                                                             1.43,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0619,    0, 'Premium All-Purpose Flour, Natural White',                                5.99,   5.0,   1,    07,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0620,    0, 'Chocolate Chip Cookie Mix, Gluten Free',                                  6.36,  22.0,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0621,    0, 'Bulgur Wheat Cereal',                                                      0.9,   1.0,   1,    00,  NULL, false);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0622,    0, 'Vanilla Yellow Cake Mix, Gluten Free',                                    4.29,  19.0,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0623,    0, 'Buttermilk Pancake Mix',                                                  3.29,  32.0,   2,    46,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0624,    0, 'Brownie Mix, Gluten Free',                                                5.63,  21.0,   2,    03,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0625,    0, 'Pumpkin Spice Pancake & Muffin Mix',                                      3.49,  24.0,   2,    46,  NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (0626,    0, 'Multi-Seed, Original',                                                    2.99,   4.5,   2,    47,  NULL,  true);

INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (1000,   12, 'Chicken Barbeque, Plate',                                                 8.79, NULL,   0,  NULL,   NULL,  true);
INSERT INTO Item(ItemCode, InStock, Description, Price, Weight, UnitID, BrandID, PictureID, EaYN) VALUES (1001,   12, 'Chicken Barbeque, Meal',                                                 11.79, NULL,   0,  NULL,   NULL,  true);

INSERT INTO Seasonal_Item(ItemCode, StartDate, EndDate) VALUES (1000, '0000-10-01', '0000-02-01');
INSERT INTO Seasonal_Item(ItemCode, StartDate, EndDate) VALUES (1001, '0000-10-01', '0000-02-01');

INSERT INTO Item_Category(ItemCode, CatID) VALUES (0001, 02);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0001, 04);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0002, 02);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0002, 04);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0003, 02);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0003, 04);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0012, 14);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0028, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0029, 16);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0039, 03);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0040, 03);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0040, 14);
INSERT INTO Item_Category(ItemCode, CatID) VALUES (0041, 14);

-------------------------------------------------------- Zac Insert Statements
INSERT INTO Zip (Zip, City, State) VALUES ('13053', 'Dryden', 'NY');
INSERT INTO Zip (Zip, City, State) VALUES ('13045', 'Cortland', 'NY');
INSERT INTO Zip (Zip, City, State) VALUES ('28310', 'Spring Lake', 'NC');
INSERT INTO Zip (Zip, City, State) VALUES ('28311', 'Fort Bragg', 'NC');
INSERT INTO Zip (Zip, City, State) VALUES ('28309', 'Fayetteville', 'NC');
INSERT INTO Zip (Zip, City, State) VALUES ('84564', 'Brunsville', 'TX');
INSERT INTO Zip (Zip, City, State) VALUES ('11111', 'Kelpos', 'SC');
INSERT INTO Zip (Zip, City, State) VALUES ('26485', 'Briggstown', 'MN');
INSERT INTO Zip (Zip, City, State) VALUES ('84982', 'Terracor', 'CO');
INSERT INTO Zip (Zip, City, State) VALUES ('91525', 'Selfur', 'MA');

INSERT INTO AddressBook (InfoID, FName, LName, Phone) VALUES (1, 'Mandy', 'Briggs', '6251648542');
INSERT INTO AddressBook (InfoID, FName, LName, Phone) VALUES (2, 'Steven', 'Turry', '9452615842');
INSERT INTO AddressBook (InfoID, FName, LName, Phone) VALUES (3, 'Kassandra', 'Alditore', '1658425478');
INSERT INTO AddressBook (InfoID, FName, LName, Phone) VALUES (4, 'Brock', 'Onix', '8459426154');
INSERT INTO AddressBook (InfoID, FName, LName, Phone) VALUES (5, 'Patrick', 'Star', '9452145666');
INSERT INTO AddressBook (InfoID, FName, LName, Phone) VALUES (6, 'Sam', 'Killington', '1111111111');
INSERT INTO AddressBook (InfoID, FName, LName, Phone) VALUES (7, 'Pedro', 'Sombrero', '2222222222');
INSERT INTO AddressBook (InfoID, FName, LName, Phone) VALUES (8, 'Jane', 'Doe', '3333333333');
INSERT INTO AddressBook (InfoID, FName, LName, Phone) VALUES (9, 'John', 'Doe', '4444444444');
INSERT INTO AddressBook (InfoID, FName, LName, Phone) VALUES (10, 'Trainy', 'McTrainface', '3333333333');

INSERT INTO AddressBook_Optional (InfoID, Email, Password, Addy1, Addy2, Zip) VALUES (1, 'gottem@gmail.com', 'password', '123 State Street', 'APT 1', '13053');
INSERT INTO AddressBook_Optional (InfoID, Email, Password, Addy1, Addy2, Zip) VALUES (2, 'Deeztrucks@yahoo.com', 'password', '456 State Street', 'APT 2', '13045');
INSERT INTO AddressBook_Optional (InfoID, Email, Password, Addy1, Addy2, Zip) VALUES (3, 'purplepeopleeater@hotmail.com', 'paSSword', 'Here and There Street', 'Up', '13053');
INSERT INTO AddressBook_Optional (InfoID, Email, Password, Addy1, Addy2, Zip) VALUES (4, 'ourlordandsaviortachanka@praisehim.com', 'Paddywack', '1234 Here Street', 'apt 32', '13045');
INSERT INTO AddressBook_Optional (InfoID, Email, Password, Addy1, Addy2, Zip) VALUES (5, 'thisissparta@greeks.com', 'Elysium', '1 Timbucktou St', 'apt 45', '28310');
INSERT INTO AddressBook_Optional (InfoID, Email, Password, Addy1, Addy2, Zip) VALUES (6, 'whereintheworldiscarmensadiago@waldo.com', 'Bant', '3 Street St', 'apt 12', '28311');
INSERT INTO AddressBook_Optional (InfoID, Email, Password, Addy1, Addy2, Zip) VALUES (7, 'WILSON!!!@castaways.com', 'Turtles', '3 Sam Hill', 'left', '91525');
INSERT INTO AddressBook_Optional (InfoID, Email, Password, Addy1, Addy2, Zip) VALUES (8, 'minime@justevil.com', 'Goldmember', '1 my evil lair St', 'apt 3', '84982');
INSERT INTO AddressBook_Optional (InfoID, Email, Password, Addy1, Addy2, Zip) VALUES (9, 'owalego@steppedonit.org', 'click', '3 Pain Street', 'apt 345', '11111');
INSERT INTO AddressBook_Optional (InfoID, Email, Password, Addy1, Addy2, Zip) VALUES (10, 'guessthisisithuh@gitgud.net', 'scrubbynoober', '10 Awesomeness Ave', 'Apt 1', '28309');

INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(1, 'Janitor', 1);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(2, 'Salesman', 1);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(3, 'Stocker', 1);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(4, 'Owner', 5);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(5, 'Craftsman', 2);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(6, 'Tax person', 4);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(7, 'Greeter', 1);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(8, 'Cashier', 2);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(9, 'Interior Lighting', 1);
INSERT INTO	Job_Title (JobID, JobTitle, PrivLvl) VALUES(10, 'Snooper', 5);

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

INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, Wage_Salary, Rate) VALUES(1, '12/07/2013', '12/07/2014',1 ,8.17);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, Wage_Salary, Rate) VALUES(2, '12/08/1994', '09/02/2019',0 ,9.50);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, Wage_Salary, Rate) VALUES(3, '05/29/1908', '03/18/1790',1 ,10.00);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, Wage_Salary, Rate) VALUES(4, '11/13/2000', '04/16/2005',0 ,4.50);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, Wage_Salary, Rate) VALUES(5, '10/22/2001', '05/23/2006',1 ,90.50);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, Wage_Salary, Rate) VALUES(6, '12/24/1999', '03/31/2006',0 ,20.53);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, Wage_Salary, Rate) VALUES(7, '11/23/1994', '02/04/2018',1 ,2.91);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, Wage_Salary, Rate) VALUES(8, '05/17/1845', '12/31/2019',0 ,0.01);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, Wage_Salary, Rate) VALUES(9, '06/17/1456', '07/25/1954',1 ,1.00);
INSERT INTO Salary_Wage (EmpID, StartDate, EndDate, Wage_Salary, Rate) VALUES(10, '07/24/1837', '02/25/1985',0 ,1.50);

INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(1, '1000-01-01 00:00:00', '9999-12-31 23:59:59');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(2, '1000-01-01 00:00:00', '9999-12-31 23:59:59');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(3, '1000-01-01 00:00:00', '9999-12-31 23:59:59');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(4, '1000-01-01 00:00:00', '9999-12-31 23:59:59');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(5, '1000-01-01 00:00:00', '9999-12-31 23:59:59');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(6, '1000-01-01 00:00:00', '9999-12-31 23:59:59');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(7, '1000-01-01 00:00:00', '9999-12-31 23:59:59');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(8, '1000-01-01 00:00:00', '9999-12-31 23:59:59');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(9, '1000-01-01 00:00:00', '9999-12-31 23:59:59');
INSERT INTO	Hours_Log (EmpID, StartDateTime, EndDateTime) VALUES(10, '1000-01-01 00:00:00', '9999-12-31 23:59:59');

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
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Supply_Order (SupOrderID,SupID,DateOrdered,TotalCost) VALUES (NULL,1,'2018-01-01 10:00:00.000000',9.99);
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

INSERT INTO Customer (CustID,InfoID) VALUES (NULL,2);
INSERT INTO Customer (CustID,InfoID) VALUES (NULL,2);
INSERT INTO Customer (CustID,InfoID) VALUES (NULL,2);
INSERT INTO Customer (CustID,InfoID) VALUES (NULL,2);
INSERT INTO Customer (CustID,InfoID) VALUES (NULL,2);
INSERT INTO Customer (CustID,InfoID) VALUES (NULL,2);
INSERT INTO Customer (CustID,InfoID) VALUES (NULL,2);
INSERT INTO Customer (CustID,InfoID) VALUES (NULL,2);
INSERT INTO Customer (CustID,InfoID) VALUES (NULL,2);
INSERT INTO Customer (CustID,InfoID) VALUES (NULL,2);

INSERT INTO Cart (CartID) VALUES (NULL);
INSERT INTO Cart (CartID) VALUES (NULL);
INSERT INTO Cart (CartID) VALUES (NULL);
INSERT INTO Cart (CartID) VALUES (NULL);
INSERT INTO Cart (CartID) VALUES (NULL);
INSERT INTO Cart (CartID) VALUES (NULL);
INSERT INTO Cart (CartID) VALUES (NULL);
INSERT INTO Cart (CartID) VALUES (NULL);
INSERT INTO Cart (CartID) VALUES (NULL);
INSERT INTO Cart (CartID) VALUES (NULL);

INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (NULL,1,1,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (NULL,2,2,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (NULL,3,3,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (NULL,4,4,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (NULL,5,5,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (NULL,6,6,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (NULL,7,7,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (NULL,8,8,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (NULL,9,9,'2018-01-01 10:00:00.000000',9.99);
INSERT INTO Customer_Order (CartID,CustID,EmpID,DateCustOrder,Subtotal) VALUES (NULL,10,10,'2018-01-01 10:00:00.000000',9.99);

INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (1,1,1,1);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (2,2,2,2);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (3,3,3,3);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (4,4,4,4);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (5,5,5,5);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (6,6,6,6);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (7,7,7,8);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (8,8,8,9);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (9,9,9,9);
INSERT INTO Cart_Item (CartID,ItemCode,AmtToSell,MeasQuantity) VALUES (10,10,10,10);


/*
       Items Query
SELECT Item.ItemCode, Item.InStock, Brand.Brand, Item.Description, Item.Price, Item.Weight, Unit.Unit
FROM Item INNER JOIN Unit INNER JOIN Brand
WHERE Item.BrandID = Brand.BrandID && Item.UnitID = Unit.UnitID && Item.ItemCode != 0000 ORDER BY Item.ItemCode;
*/