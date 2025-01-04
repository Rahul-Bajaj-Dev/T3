-- Create the 'Artists' table
CREATE TABLE Artists (
    ArtistID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Bio TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the 'Artwork' table
CREATE TABLE Artwork (
    ArtworkID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    ArtistID INT,
    ListingDate DATE NOT NULL,
    AvailabilityStatus ENUM('available', 'sold') DEFAULT 'available',
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID)
);

-- Create the 'Categories' table
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(255) UNIQUE NOT NULL
);

-- Create the 'ArtworkCategories' table (many-to-many relationship between Artwork and Categories)
CREATE TABLE ArtworkCategories (
    ArtworkID INT,
    CategoryID INT,
    PRIMARY KEY (ArtworkID, CategoryID),
    FOREIGN KEY (ArtworkID) REFERENCES Artwork(ArtworkID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Create the 'Buyers' table
CREATE TABLE Buyers (
    BuyerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    ShippingAddress TEXT NOT NULL,
    BillingAddress TEXT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the 'Reviews' table
CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    ArtworkID INT,
    BuyerID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ArtworkID) REFERENCES Artwork(ArtworkID),
    FOREIGN KEY (BuyerID) REFERENCES Buyers(BuyerID)
);

-- Create the 'Orders' table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    BuyerID INT,
    PurchaseDate DATE NOT NULL,
    TotalPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (BuyerID) REFERENCES Buyers(BuyerID)
);

-- Create the 'OrderDetails' table (many-to-many relationship between Orders and Artwork)
CREATE TABLE OrderDetails (
    OrderID INT,
    ArtworkID INT,
    PRIMARY KEY (OrderID, ArtworkID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ArtworkID) REFERENCES Artwork(ArtworkID)
);

-- Sample query to retrieve all artworks by a particular artist, sorted by their listing date
SELECT *
FROM Artwork
WHERE ArtistID = ?
ORDER BY ListingDate DESC;

-- Sample query to determine the average price of artworks within a specific category
SELECT AVG(a.Price) AS AveragePrice
FROM Artwork a
JOIN ArtworkCategories ac ON a.ArtworkID = ac.ArtworkID
JOIN Categories c ON ac.CategoryID = c.CategoryID
WHERE c.CategoryName = ?;
