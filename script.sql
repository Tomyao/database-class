CREATE TABLE Product (
	maker 		character(1),
	model 		int,
	type 		enum('pc', 'laptop', 'printer')
);

CREATE TABLE PC (
	model 		int,
	speed 		float,
	ram 		int,
	hd 		int,
	price 		int
);

CREATE TABLE Laptop (
	model 		int,
	speed 		float,
	ram 		int,
	hd 		int,
	screen 	float,
	price 		int
);

CREATE TABLE Printer (
	model 		int,
	color 		boolean,
	type 		enum('ink-jet', 'laser'),
	price 		int
);

INSERT INTO Product (maker, model, type)
VALUES 
	('A', 1001, 'pc'),
	('A', 1002, 'pc'),
	('A', 1003, 'pc'),
	('A', 2004, 'laptop'),
	('A', 2005, 'laptop'),
	('A', 2006, 'laptop'),
	('B', 1004, 'pc'),
	('B', 1005, 'pc'),
	('B', 1006, 'pc'),
	('B', 2007, 'laptop'),
	('C', 1007, 'pc'),
	('D', 1008, 'pc'),
	('D', 1009, 'pc'),
	('D', 1010, 'pc'),
	('D', 3004, 'printer'),
	('D', 3005, 'printer'),
	('E', 1011, 'pc'),
	('E', 1012, 'pc'),
	('E', 1013, 'pc'),
	('E', 2001, 'laptop'),
	('E', 2002, 'laptop'),
	('E', 2003, 'laptop'),
	('E', 3001, 'printer'),
	('E', 3002, 'printer'),
	('E', 3003, 'printer'),
	('F', 2008, 'laptop'),
	('F', 2009, 'laptop'),
	('G', 2010, 'laptop'),
	('H', 3006, 'printer'),
	('H', 3007, 'printer');

INSERT INTO PC (model, speed, ram, hd, price)
VALUES
	(1001, 2.66, 1024, 250, 2114),
	(1002, 2.10, 512, 250, 995),
	(1003, 1.42, 512, 80, 478),
	(1004, 2.80, 1024, 250, 649),
	(1005, 3.20, 512, 250, 630),
	(1006, 3.20, 1024, 320, 1049),
	(1007, 2.20, 1024, 200, 510),
	(1008, 2.20, 2048, 250, 770),
	(1009, 2.00, 1024, 250, 650),
	(1010, 2.80, 2048, 300, 770),
	(1011, 1.86, 2048, 160, 959),
	(1012, 2.80, 1024, 160, 649),
	(1013, 3.06, 512, 80, 529);

INSERT INTO Laptop (model, speed, ram, hd, screen, price)
VALUES
	(2001, 2.00, 2048, 240, 20.1, 3673),
	(2002, 1.73, 1024, 80, 17.0, 949),
	(2003, 1.80, 512, 60, 15.4, 549),
	(2004, 2.00, 512, 60, 13.3, 1150),
	(2005, 2.16, 1024, 120, 17.0, 2500),
	(2006, 2.00, 2048, 80, 15.4, 1700),
	(2007, 1.83, 1024, 120, 13.3, 1429),
	(2008, 1.60, 1024, 100, 15.4, 900),
	(2009, 1.60, 512, 80, 14.1, 680),
	(2010, 2.00, 2048, 160, 15.4, 2300);

INSERT INTO Printer (model, color, type, price)
VALUES
	(3001, true, 'ink-jet', 99),
	(3002, false, 'laser', 239),
	(3003, true, 'laser', 899),
	(3004, true, 'ink-jet', 120),
	(3005, false, 'laser', 120),
	(3006, true, 'ink-jet', 100),
	(3007, true, 'laser', 200);

	SELECT DISTINCT A.maker FROM Product A
	WHERE A.model IN (
		SELECT B.model FROM PC B
		WHERE B.speed >= 3.0
	);

	SELECT A.model FROM Printer A
	WHERE A.price IN (
		SELECT MAX(price) FROM Printer
	);

	SELECT A.model FROM Laptop A
	WHERE A.speed < (
		SELECT MIN(speed) FROM PC
	);

	SELECT model FROM (
		SELECT model, price  FROM Laptop
		UNION
		SELECT model, price  FROM PC
		UNION
		SELECT model, price FROM Printer) AS prices1
	WHERE price IN (
		SELECT MAX(price) FROM (
			SELECT model, price  FROM Laptop
			UNION
			SELECT model, price  FROM PC
			UNION
			SELECT model, price FROM Printer) AS prices2
	);

	SELECT DISTINCT A.maker FROM Product A
	WHERE A.model IN (
		SELECT B.model FROM Printer B
		WHERE B.price IN (
			SELECT MIN(C.price) FROM Printer C
			WHERE B.color = true
		)
	);

	SELECT DISTINCT A.maker FROM Product A
	WHERE A.model IN (
		SELECT B.model FROM PC B
		WHERE B.speed IN (
			SELECT MAX(C.speed) FROM PC C
			WHERE C.ram IN (
				SELECT MIN(ram) FROM PC
			)
		)
	);

	CREATE TABLE ProductBackup SELECT * FROM Product;
	CREATE TABLE PCBackup SELECT * FROM PC;
	CREATE TABLE LaptopBackup SELECT * FROM Laptop;
	CREATE TABLE PrinterBackup SELECT * FROM Printer;

	INSERT INTO Product (maker, model, type)
	VALUES ('C', 1100, 'PC');

	INSERT INTO PC (model, speed, ram, hd, price)
	VALUES(1100, 3.2, 1024, 180, 2499);

	DROP TABLE Product;
	DROP TABLE PC;
	DROP TABLE Laptop;
	DROP TABLE Printer;

	CREATE TABLE Product SELECT * FROM ProductBackup;
	CREATE TABLE PC SELECT * FROM PCBackup;
	CREATE TABLE Laptop SELECT * FROM LaptopBackup;
	CREATE TABLE Printer SELECT * FROM PrinterBackup;

	INSERT INTO Product (maker, model, type)
	SELECT	A.maker,
			A.model + 1100,
			'Laptop'
	FROM Product A, PC B
	WHERE A.model = B.model;

	INSERT INTO Laptop (model, speed, ram, hd, screen, price)
	SELECT	model + 1100,
			speed,
			ram,
			hd,
			17.0,
			price + 500
	FROM PC;

	DROP TABLE Product;
	DROP TABLE PC;
	DROP TABLE Laptop;
	DROP TABLE Printer;

	CREATE TABLE Product SELECT * FROM ProductBackup;
	CREATE TABLE PC SELECT * FROM PCBackup;
	CREATE TABLE Laptop SELECT * FROM LaptopBackup;
	CREATE TABLE Printer SELECT * FROM PrinterBackup;

	DELETE FROM Product, PC
	USING Product JOIN PC
	ON Product.model = PC.model
	WHERE PC.hd < 100;

	DROP TABLE Product;
	DROP TABLE PC;
	DROP TABLE Laptop;
	DROP TABLE Printer;

	CREATE TABLE Product SELECT * FROM ProductBackup;
	CREATE TABLE PC SELECT * FROM PCBackup;
	CREATE TABLE Laptop SELECT * FROM LaptopBackup;
	CREATE TABLE Printer SELECT * FROM PrinterBackup;

	DELETE FROM Product, Laptop
	USING Product JOIN Laptop
	ON Product.model = Laptop.model
	WHERE Product.maker NOT IN (
		SELECT maker FROM (SELECT * FROM Product) AS Temp JOIN Printer
		ON Temp.model = Printer.model
	);

	DROP TABLE Product;
	DROP TABLE PC;
	DROP TABLE Laptop;
	DROP TABLE Printer;

	CREATE TABLE Product SELECT * FROM ProductBackup;
	CREATE TABLE PC SELECT * FROM PCBackup;
	CREATE TABLE Laptop SELECT * FROM LaptopBackup;
	CREATE TABLE Printer SELECT * FROM PrinterBackup;

	UPDATE Product
	SET maker = 'A'
	WHERE maker = 'B';

	DROP TABLE Product;
	DROP TABLE PC;
	DROP TABLE Laptop;
	DROP TABLE Printer;

	CREATE TABLE Product SELECT * FROM ProductBackup;
	CREATE TABLE PC SELECT * FROM PCBackup;
	CREATE TABLE Laptop SELECT * FROM LaptopBackup;
	CREATE TABLE Printer SELECT * FROM PrinterBackup;

	UPDATE PC
	SET ram = ram*2, hd = hd + 60;

	DROP TABLE Product;
	DROP TABLE PC;
	DROP TABLE Laptop;
	DROP TABLE Printer;

	CREATE TABLE Product SELECT * FROM ProductBackup;
	CREATE TABLE PC SELECT * FROM PCBackup;
	CREATE TABLE Laptop SELECT * FROM LaptopBackup;
	CREATE TABLE Printer SELECT * FROM PrinterBackup;

	UPDATE Laptop
	SET screen = screen + 1, price = price - 100
	WHERE model in (
		SELECT model FROM Product
		WHERE maker = 'B'
	);

	DROP TABLE Product;
	DROP TABLE PC;
	DROP TABLE Laptop;
	DROP TABLE Printer;

	CREATE TABLE Product SELECT * FROM ProductBackup;
	CREATE TABLE PC SELECT * FROM PCBackup;
	CREATE TABLE Laptop SELECT * FROM LaptopBackup;
	CREATE TABLE Printer SELECT * FROM PrinterBackup;
